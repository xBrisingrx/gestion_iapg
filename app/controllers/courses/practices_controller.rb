class Courses::PracticesController < ApplicationController
  def new
    @people = Person.actives.select(:id, :name, :last_name, :cuil)
    @companies = Company.actives.select(:name, :cuit, :id)
    @operators = @companies.where(operator: true)
  end

  def create
    ActiveRecord::Base.transaction do
      data = {
        person_id: params[:person_id],
        company_id: params[:company_id],
        manager_id: params[:course_person][:manager_id],
        operator_id: params[:operator_id],
        fleet_category_id: params[:fleet_category_id],
        inscription_motive_id: params[:inscription_motive_id],
        is_free: params[:is_free]
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
