class Api::ElearningController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate

  def index
    person = Person.find_by(cuil: params[:cuil]) # buscamos a la persona que va a hacer el curso
    if person.blank?
      render json: { message: "No se puede acceder a sus datos en este momento.", error: true }
    else
      # si el codigo no es unico, vamos atener q sumar filtrar por fecha de vigencia
      course_person = CoursePerson.where(person: person, code: params[:code])
      if  course_person.blank?
        render json: { message: "Datos incorrectos.", error: true }
      elsif course_person.last.scoring_theoric > 0
        render json: { message: "Ya ha realizado el curso.", error: true }
      else
        course_person = course_person.last
        iat = Time.new.to_i
        exp = iat * (60 * 60)
        fleet =  { light: "L", heavy: "P", both: "A" }
        token = jwt_encode({
          iat: iat,
          exp: exp,
          data: {
            id: person.id,
            cuil: person.cuil,
            apellido: person.last_name,
            nombre: person.name,
            curso: course_person.course_id,
            examen: course_person.course.course_exams.first.exam_id,
            cupo: "353847",
            tipo: "empresa",
            tipocupo: fleet[course_person.course.course_type.fleet.to_sym]
          }
        })

        dias_disponible = CourseTypeUnit.unit_of_theory(course_person.course.course_type.id).days_of_duration
        from_date = course_person.course.from_date
        to_date = from_date + (dias_disponible.days - 1)
        today = Date.today
        range = from_date..to_date
          # if range.include? today
          render json: { message: "Successful login.", jwt: token }
        # else
        # render json: { message: "Este curso se puede hacer desde #{from_date.strftime("%d-%m-%y")} hastas #{to_date.strftime("%d-%m-%y")}" }
        # end
      end # if course_person.blank?
    end # if person.blank?
  end

  def get_course_module
    jwt = request.headers["Authorization"].split(" ").last
    decode = jwt_decode(jwt)
    data = decode["data"]
    # buscamos los modulos del examen que debemos mostrar
    exam_modules = ExamModule.where(exam_id: data["examen"], quote_type: data["tipocupo"])
    exam = []
    cant_preguntas = 0
    exam_modules.each do |exam_module|
      questions = exam_module.questions.order("RAND()")
      module_questions = []
      cant_preguntas = cant_preguntas + questions.count

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
    render json: { curso: exam, examen: exam, cant_preguntas: cant_preguntas, error: false }
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
      message = "Ah contestado mal una pregunta eliminatoria."
      porcent = 1
      status = false
      # render json: { message: "Desaprobado por errarle a una eliminatoria", correcto: 1, resultado: 0, estado: false, id: 1  }
    else
      porcent = questions_corrects*100/cant_questions
      if porcent >= 80
        message = "Felicitaciones"
        status = true
        # render json: { message: "Crack", correcto: porcent, resultado: 1, estado: true  }
      else
        message = "Desaprobado"
        # render json: { message: "Fallido", correcto: porcent, resultado: 0, estado: false  }
      end
    end # end if person_deleted
    questionnaires = Questionnaire.select("id, question AS pregunta, q_type AS tipo, q_order AS orden").all.order(q_order: :asc)
    course_person.first.update(scoring: porcent, attendance_status: :presence)
    CoursePerson.check_approved(course_person)
    render json: { message: message, correcto: porcent, resultado: status, encuesta: questionnaires }
  end # end get_resultsdos

  def encuesta
    jwt = request.headers["Authorization"].split(" ").last
    decode = jwt_decode(jwt)
    data = decode["data"]
    person = Person.find_by(cuil: data["cuil"])
    surveys = params[:encuesta]
    surveys.each do |survey|
      Survey.create(
        person: person,
        course_id: data["curso"].to_i,
        question: survey[0],
        answer: survey[1]
      )
    end
    render json: { message: "Gracias por participar de la encuesta", resultado: true }
  end
end
