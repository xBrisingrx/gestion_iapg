class Api::CredentialController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate

  def login
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
    render json: { message: "curso aprobado", error: false }
  end
end
