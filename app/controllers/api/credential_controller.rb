class Api::CredentialController < ApplicationController
  require "mini_magick"
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate

  def login
    # tengo que atajar cuando la persona no existe
    person = Person.find_by(cuil: params[:id]) # buscamos a la persona que solicita la credencial
    iat = Time.new.to_i
    exp = iat * (60 * 60)
    token = jwt_encode({
      iat: iat,
      exp: exp,
      data: {
        id: person.id,
        cuil: person.cuil,
        apellido: person.last_name,
        nombre: person.name,
        credencial: 1
      }
    })
    render json: { message: "Successful login.", jwt: token, code: "1234" }
  end

  def credential_person_data
    jwt = request.headers["Authorization"].split(" ").last
    decode = jwt_decode(jwt)
    data = decode["data"]
    person = Person.find_by(id: data["id"])
    persona = {
        nombre: person.name,
        apellido: person.last_name,
        cuil: person.cuil,
        code: person.code,
        fechanacimiento: person.birthdate,
        telefono: person.phone,
        nrocelular: person.phone,
        mail: person.email,
        domicilio: person.direction,
        localidad: person.city.name,
        provincia: person.province.name,
        idlocalidad: "1548",
        dueno: "117"
    }

    # if

    # else
    # end
    render json: { persona: persona, error: false }
  end

  def get_course_module
    jwt = request.headers["Authorization"].split(" ").last
    decode = jwt_decode(jwt)
    data = decode["data"]
    # buscamos los modulos del examen que debemos mostrar
    exam_modules = ExamModule.where(exam_id: data["examen"], quote_type: data["tipocupo"])
    exam = []
    exam_modules.each do |exam_module|
      questions = exam_module.questions.order("RAND()")

      module_questions = []

      questions.each do |question|
        answers = question.answers.select(:id, :answer).actives
        q = {
          id: question.id,
          pregunta: question.question,
          imagen: "",
          respuestas: answers.map { |a| { id: a.id, respuesta: a.answer } }
        }
        module_questions.push(q)
      end
      exam_module_data = {
        id: exam_module.id,
        preguntas: module_questions,
        videos: exam_module.videos.map { |v| { id: v.id, title: v.title, code: v.code, vimeo: v.vimeo } }
      }
      exam.push(exam_module_data)
    end
    render json: { curso: exam, error: false }
  end

  def get_resultados
    jwt = request.headers["Authorization"].split(" ").last
    decode = jwt_decode(jwt)
    data = decode["data"]
    # obtenemos el total de preguntas que tienen los modulos
    cant_questions = ExamModule.where(exam_id: data["examen"], quote_type: data["tipocupo"])
                    .joins(:module_questions)
                    .count("exam_modules.id")
    course_person = CoursePerson.where(person_id: data["id"], course_id: data["curso"]).joins(:unit).where(unit: { category: "Teorico" })

    questions_corrects = 0
    person_deleted = false
    questions_answers = params["_json"] # aca nos llegan las preguntas respondidas con sus respectivas respuestas
    questions_answers.each do |d|
      data_answers = Answer.select("answers.id, answers.correct, questions.eliminating")
                      .where(question_id: d["pregunta_id"])
                      .joins(:question)
      data_answers.each do |answer|
        correct = false
        if answer.id == d["respuesta"]
          if answer.correct
            correct = true
          elsif answer.eliminating
            person_deleted = true
          end
        elsif answer.correct && answer.eliminating
          person_deleted = true
        end # answer.id == d["respuesta"]
        break if person_deleted
        if correct
          questions_corrects = questions_corrects + 1
        end
      end # data_answers.each
    end # end questions_answers each

    if person_deleted
      message = "Desaprobado por errarle a una eliminatoria"
      porcent = 1
      status = false
      # render json: { message: "Desaprobado por errarle a una eliminatoria", correcto: 1, resultado: 0, estado: false, id: 1  }
    else
      porcent = questions_corrects*100/cant_questions
      if porcent >= 80
        message = "Crack"
        status = true
        # render json: { message: "Crack", correcto: porcent, resultado: 1, estado: true  }
      else
        message = "Fallido"
        # render json: { message: "Fallido", correcto: porcent, resultado: 0, estado: false  }
      end
    end # end if person_deleted
    questionnaires = Questionnaire.select("id, question AS pregunta, q_type AS tipo, q_order AS orden").all.order(q_order: :asc)
    course_person.first.update(scoring: porcent, attendance_status: :presence)
    render json: { message: message, correcto: porcent, resultado: status, encuesta: questionnaires }
  end # end get_resultsdos

  def provincias
    provinces = Province.all.select("id AS idprovincia, name AS nombre")
    render json: { provincias: provinces, erorr: false }
  end

  def localidades
    localidades = City.all.select("id AS idlocalidad, name AS nombre")
    render json: { localidades: localidades, erorr: false }
  end

  def empresas
    empresas = Company.all.select("id AS idempresa, name AS razonsocial")
    render json: { empresas: empresas, erorr: false }
  end

  def savedatos
    render json: { save: true, error: false }
  end

  def validar
    jwt = request.headers["Authorization"].split(" ").last
    decode = jwt_decode(jwt)
    data = decode["data"]
    person = Person.find_by(id: data["id"])
    course_people = person.course_people
    teorico = course_people.where(approved: true).where("expiration_date >= ? ", "#{Date.today}").joins(:unit).where(units: { category: "Teorico" }).last
    if teorico.blank? 
      credential_invalid = false
    else
      limit_date = teorico.date - 6.month
      practicos = course_people.where(approved: true).where("expiration_date >= ? ", "#{limit_date}").joins(:unit).where(units: { category: "Practico" })
      psicometrico = course_people.where(attendance_status: :presence).where("expiration_date >= ? ", "#{limit_date}").joins(:unit).where(units: { category: "Psicometrico" })
      credential_invalid = practicos.blank? || psicometrico.blank?
    end
    
    if credential_invalid
      render json: { message: "Falta aprobar alguna de las instancias.", error: true }
    else
      render json: { message: "curso aprobado", error: false }
    end
  end

  def mostrar_credencial
    # jwt = request.headers["HTTP_JWT"].split(" ").last
    person = Person.find_by(cuil: params[:c].to_i)
    course_people = person.course_people
    teorico = course_people.where(approved: true).joins(:unit).where(units: { category: "Teorico" }).last
    limit_date = teorico.date - 6.month
    practicos = course_people.where(approved: true)
                              .where("expiration_date >= ? ", "#{limit_date}")
                              .joins(:unit)
                                .where(units: { category: "Practico" })
    psicometrico = course_people.where(attendance_status: :presence)
                                .where("expiration_date >= ? ", "#{limit_date}")
                                .joins(:unit)
                                  .where(units: { category: "Psicometrico" })
    meses = [ nil, "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre" ]
    credential_date = teorico.expiration_date
    w = (params[:w] || 1024).to_i - 10
    h = (params[:h] || 768).to_i

    hnew = (w * 1.4).round
    h = hnew if hnew < h

    col1 = (42 * w / 100.0).round
    col2 = w - col1
    # Lógica de tamaño de fuente del nombre
    fsname = 9.0
    prop = w.to_f / h
    dia = credential_date.day
    anio = credential_date.year
    mes = meses[credential_date.month]

    nombre = person.fullname
    cuil = person.cuil
    categoria = practiso.map { |practico| categoria + "#{practico.fleet_category.name} - " }

    face = (!person.images.blank?) ? MiniMagick::Image.read(person.images.last.download) : MiniMagick::Image.open(Rails.root.join("app/assets/images/credencial/faces/no_face.png"))
    firma = MiniMagick::Image.open(Rails.root.join("app/assets/images/credencial/firma.png"))
    logoecd = MiniMagick::Image.open(Rails.root.join("app/assets/images/credencial/ecd.png"))
    logoiapgsur = MiniMagick::Image.open(Rails.root.join("app/assets/images/credencial/logo-sur.png"))

    lato_font = Rails.root.join("app/assets/images/fonts/Lato-Regular.ttf")
    impact_font = Rails.root.join("app/assets/images/fonts/Impact.ttf")
    gotham_font = Rails.root.join("app/assets/images/fonts/GothamBlack.ttf")
    sharetech_font = Rails.root.join("app/assets/images/fonts/ShareTechMono-Regular.ttf")

    face.resize "#{col2}x#{(col2 * prop).round}>"
    logoiapgsur.resize "#{(w / 3.0).round}x"
    logoecd.resize "#{(w / 7.5).round}x"
    firma.resize "#{(w / 4.5).round}x"

    # === Crear panel de validez (vence) ===
    vence = MiniMagick::Image.new(Rails.root.join("tmp/vence.png"), "png")
    MiniMagick::Tool::Magick.new do |m|
      m.size "#{col2}x#{(col2 / 1.45).round}"
      m.canvas "#00568f"
      m.gravity "northwest"
      m.fill "white"
      m.font lato_font.to_s
      m.pointsize (w * 3 / 100.0).round
      m.draw "text 20,10 'Válido hasta'"
      m.font impact_font.to_s
      m.pointsize (w * 8 / 100.0).round
      m.gravity "northeast"
      m.draw "text 1,5 '#{dia} de'"
      m.draw "text 1,#{(w * 10 / 100.0).round} '#{mes} de'"
      m.gravity "southeast"
      m.pointsize (w * 22 / 100.0).round
      m.draw "text 1,-10 '#{anio}'"
      m << Rails.root.join("tmp/vence.png")
    end
    vence = MiniMagick::Image.open(Rails.root.join("tmp/vence.png"))

    # === Crear label con nombre, cuil y categoría ===
    label = MiniMagick::Image.new(Rails.root.join("tmp/label.png"), "png")
    MiniMagick::Tool::Magick.new do |m|
      m.size "#{w}x#{(h / 5.9).round}"
      # m.canvas "white"
      m.xc "none"    # fondo transparente
      m.gravity "north"
      m.font gotham_font.to_s
      m.pointsize (w * 7 / 100.0).round
      m.draw "text 0,0 '#{nombre}'"
      m.font sharetech_font.to_s
      m.pointsize (w * 9 / 100.0).round
      m.draw "text 0,#{(w * 8 / 100.0).round} '#{cuil}'"
      m.font lato_font.to_s
      m.pointsize (w * 4.5 / 100.0).round
      m.draw "text 0,#{(w * 18 / 100.0).round} '#{categoria}'"
      m << Rails.root.join("tmp/label.png")
    end
    label = MiniMagick::Image.open(Rails.root.join("tmp/label.png"))

    detalle = MiniMagick::Image.new(Rails.root.join("tmp/detalle.png"), "png")
    MiniMagick::Tool::Magick.new do |m|
      m.size "#{col1}x#{(col2 / 1.45).round}!"
      m.canvas "#021d49"
      m.fill "white"
      m.gravity "north"
      m << Rails.root.join("tmp/detalle.png")
    end
    detalle = MiniMagick::Image.open(Rails.root.join("tmp/detalle.png"))

    detalle.combine_options do |canvas|
      canvas.font lato_font
      canvas.fill "white"

      canvas.pointsize (w * 2.8 / 100.0).round
      canvas.gravity "NorthWest"
      canvas.draw "text 5,#{(w * 10 / 100.0).round} 'APROBÓ LA EVALUACIÓN'"

      if !teorico.blank?
        canvas.draw "text 5,#{(w * 15 / 100.0).round} 'TEORICA'"
      end

      if !practicos.blank?
        canvas.draw "text 5,#{(w * 15 / 100.0).round} 'PRÁCTICA DEL CURSO DE'"
      end
      if !psicometrico.blank?
        canvas.draw "text 5,#{(w * 25 / 100.0).round} 'Y REALIZÓ EL'"
        canvas.draw "text 5,#{(w * 30 / 100.0).round} 'EXAMEN PSICOMÉTRICO'"
      end
      canvas.draw "text 5,#{(w * 20 / 100.0).round} 'CONDUCCIÓN DEFENSIVA'"
    end

    image = MiniMagick::Image.open(Rails.root.join("app/assets/images/base-1.png"))
    # Superponer imágenes en posiciones similares al PHP original
    image = overlay(image, face,        "NorthEast", -10, 10)
    image = overlay(image, logoiapgsur, "NorthWest", 10, ((face.height - logoiapgsur.height) / 2.0))
    image = overlay(image, label,       "North",     0,  face.height + 20)
    image = overlay(image, vence,       "NorthEast", 0,  face.height + 20 + label.height + 10)
    image = overlay(image, detalle,     "NorthWest", 0,  face.height + 20 + label.height + 10)
    image = overlay(image, logoecd,     "SouthWest", 35, 0)
    image = overlay(image, firma,       "SouthEast", 5, 0)
    # ==== Mostrar o guardar ====
    image.write Rails.root.join("tmp/tarjeta.png")
    send_data image.to_blob, type: "image/png", disposition: "inline"
  end


  # Función helper para agregar texto (simulando ->text)
  def draw_text(image, text, opts = {})
    image.combine_options do |c|
      c.font opts[:font]
      c.fill opts[:color] || "black"
      c.gravity opts[:gravity] || "north"
      c.pointsize opts[:size]
      c.draw "text #{opts[:x_offset] || 0},#{opts[:y_offset] || 0} '#{text}'"
    end
  end

  # Helper para aplicar overlays
  def overlay(base, overlay, gravity, x_offset = 0, y_offset = 0)
    base.composite(overlay) do |c|
      c.colorspace "sRGB"
      c.gravity gravity
      c.geometry "+#{x_offset}+#{y_offset}"
      c.compose "over"
    end
  end
end
