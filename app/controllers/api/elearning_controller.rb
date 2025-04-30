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
end
