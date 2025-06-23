class Courses::TheoricController < ApplicationController
  # este controlador lo usamos para registrar a una persona en una teoria de forma individual
  # generalmente es cuando desaprobaron o estuvieron ausentes
  def new
    @people = CoursePerson.personas_con_teoria_desaprobada_o_ausente
  end

  def create
    ActiveRecord::Base.transaction do
      data = {
        person_id: params[:person_id],
        company_id: params[:company_id],
        manager_id: params[:course_person][:manager_id],
        operator_id: params[:operator_id],
        fleet_category_id: params[:fleet_category_id],
        inscription_motive_id: params[:inscription_motive_id]
      }
      course_person_teoria = CoursePerson.new(data)
      course_person_teoria.date = params[:course][:date_teorico],
      course_person_teoria.course_unit_id = params[:course][:teorico_id]
      course_person_teoria.register_renovation
    end # transaction
  rescue ActiveRecord::StatementInvalid
    render json: "bugssssss", status: :unprocessable_entity

    if course_person_teoria
      render json: "Registro exitoso", status: :ok
    end
  end
end
