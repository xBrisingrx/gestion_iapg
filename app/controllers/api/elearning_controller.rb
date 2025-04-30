class Api::ElearningController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate

  def index
    puts params
    person = Person.find_by(cuil: params[:cuil]) # buscamos a la persona que va a hacer el curso
    course_person = CoursePerson.find_by(person: person, code: params[:code])
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
    render json: { message: "Successful login.", jwt: token }
  end

  def get_course_module
    jwt = request.headers["Authorization"].split(" ").last
    decode = jwt_decode(jwt)
    data = decode["data"]
    # buscamos los modulos del examen que debemos mostrar
    exam_modules = ExamModule.where(exam_id: data["examen"], quote_type: data["tipocupo"], id: 14)
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
    questions_corrects = 0
    person_deleted = false

    data.each do |d|
      data_answers = Answer.select("answers.id, answers.correct, questions.eliminating")
                      .where(question_id: d["pregunta_id"])
                      .joins(:question)
      correct = false
      data_answers.each do |answer|
        if answer.id == d["respuesta"]
          if answer.correct
            correct = true
          elsif answer.eliminating
            person_deleted = true
            break
          end
        elsif answer.correct && answer.eliminating
          person_deleted = true
          break
        end # answer.id == d["respuesta"]
        break if person_deleted
        if correct
          questions_corrects = questions_corrects + 1
        end
      end # data_answers.each

      if person_deleted
        render json: { message: "Desaprobado por errarle a una eliminatoria", correcto: 1, resultado: 0, estado: false, id: 1  }
      else
        porcent = questions_corrects*100/cant_questions
        if porcent > 80
          render json: { message: "Crack", correcto: porcent, resultado: 1, estado: true  }
        else
          render json: { message: "Fallido", correcto: porcent, resultado: 0, estado: false  }
        end
      end
    end
  end
end
