class Courses::PsicometricController < ApplicationController
  # este controlador lo usamos para registrar a una persona en un psicometrico de forma individual
  # generalmente es cuando desaprobaron o estuvieron ausentes
  def new
    @people = CoursePerson.personas_con_psicometrico_desaprobada_o_ausente
    @courses = CourseUnit
                  .joins(:unit)
                  .joins(:course)
                  .where(units: { category: "Psicometrico" })
                  .where(courses: { is_company: false })
                  .order(:date)
                  .group(:course_id)
  end

  def create
    ActiveRecord::Base.transaction do
      course_person = CoursePerson.where(person_id: params[:person_id]).joins(:unit).where(units: { category: "Psicometrico" }).last
      data = {
        person_id: course_person.person_id,
        company_id: course_person.company_id,
        manager_id: course_person.manager_id,
        operator_id: course_person.operator_id,
        fleet_category_id: course_person.fleet_category_id,
        inscription_motive_id: course_person.inscription_motive_id
      }
      course_person_psicometrico = CoursePerson.new(data)
      course_person_psicometrico.date = params[:course][:date_psicometrico],
      course_person_psicometrico.course_unit_id = params[:course][:psicometrico_id]
      course_person_psicometrico.register_renovation
    end # transaction
  rescue ActiveRecord::StatementInvalid
    render json: "bugssssss", status: :unprocessable_entity

    if course_person_psicometrico
      render json: "Registro exitoso", status: :ok
    end
  end
end
