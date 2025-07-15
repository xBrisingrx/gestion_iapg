class CertificatesController < ApplicationController
  def index
  end

  def courses_by_type
    @courses = Course.where(course_type_id: params[:course_type_id]).includes(:room).order(from_date: :desc)
  end

  def get_people_in_course
    @query = CoursePerson.where(course_id: params[:course_id], operator_id: params[:operator_id]).ransack(params[:query])
    # @query = Person.where(id: @ids).actives.ransack(params[:query])
    @pagy, @course_people = pagy(@query.result.group(:person_id))
    render :people_in_course
  end

  def generate_certificate
    course_person = CoursePerson.find_by(id: params[:course_person_id])
    course_units = course_person.course.course_units
    instructor = course_units.joins(:unit).where(units: { category: "Practico" })&.first&.instructor&.person&.fullname
    from_date = course_person.course.from_date
    to_date = from_date + 2.years
    aprobado = course_person.get_aprobado_text

    doc = Prawn::Document.new
    doc.font "Helvetica"
    doc.image Rails.root.join("app/assets/images/plantilla_certificado.png"), at: [ -20, 800 ], scale: 0.25
    doc.draw_text course_person.person.fullname, style: :bold, size: 14, at: [ 210, 490 ]
    doc.draw_text course_person.person.cuil, style: :bold, size: 14, at: [ 140, 460 ]
    doc.draw_text course_person.company.name, style: :bold, size: 14, at: [ 155, 435 ]
    doc.draw_text course_person.fleet_category.name, style: :bold, size: 14, at: [ 155, 402 ]
    doc.draw_text course_person.inscription_motive.name, style: :bold, size: 14, at: [ 155, 372 ]
    doc.draw_text from_date.strftime("%d-%m-%y"), style: :bold, size: 14, at: [ 155, 345 ]
    doc.draw_text instructor, style: :bold, size: 14, at: [ 155, 315 ]
    doc.draw_text to_date.strftime("%d-%m-%y"), style: :bold, size: 14, at: [ 300, 285 ]
    doc.draw_text aprobado, style: :bold, size: 14, at: [ 60, 220 ]

    doc.render_file("public/plantilla_certificado_editado_2c.pdf")

    send_file(Rails.root.join("public/plantilla_certificado_editado_2c.pdf"), filename: "filename", type: "application/pdf", disposition: "attachment")
  end
end
