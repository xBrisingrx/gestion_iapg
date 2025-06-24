class Courses::InCompanyController < ApplicationController
  def new
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

      if !params[:course][:practico_id].blank?
        course_person_practica = CoursePerson.new(data)
      course_person_practica.date = params[:course][:date_practico],
      course_person_practica.course_unit_id = params[:course][:practico_id]
      course_person_practica.register_renovation
      end

      if !params[:course][:psicometrico_id].blank?
        course_person_psicometrico = CoursePerson.new(data)
        course_person_psicometrico.date = params[:course][:date_psicometrico],
        course_person_psicometrico.course_unit_id = params[:course][:psicometrico_id]
        course_person_psicometrico.register_renovation
      end
    end # transaction
  rescue ActiveRecord::StatementInvalid
    render json: "bugssssss", status: :unprocessable_entity

    if course_person_psicometrico.id && course_person_practica.id && course_person_teoria
      render json: "Registro exitoso", status: :ok
    end
  end
end
