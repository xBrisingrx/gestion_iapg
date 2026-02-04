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

  def modal_particular
    @people = Person.actives.select(:id, :name, :last_name, :cuil)
    @companies = Company.select(:id, :name, :cuit).actives.where(operator: true)
  end

  def registrar_particular
    # agregamos una persona a un curso de teoria
    company = Company.find_by(name: "Particular")
    data = {
      person_id: params[:person_id],
      company: company,
      manager: company.company_managers.first.person,
      operator_id: params[:operator_id],
      fleet_category_id: params[:fleet_category_id],
      inscription_motive_id: params[:inscription_motive_id]
    }
    course_person_teoria = CoursePerson.new(data)
    # course_person_teoria.date = params[:course][:date_teorico],
    course_person_teoria.course_unit_id = params[:course][:teorico_id]

    respond_to do |format|
      if course_person_teoria.register_particular
        format.turbo_stream {
          render turbo_stream: [
              turbo_stream.replace("toasts",
                partial: "shared/toasts",
                locals: { message: "Inscripción exitosa.", status_class: "primary" })
          ]
        }
      else
        @people = CoursePerson.personas_con_teoria_desaprobada_o_ausente
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: course_person_teoria.errors, status: :unprocessable_entity }
      end
    end
  end
end
