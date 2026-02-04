class Clients::RegistrationCourseController < ApplicationController
  def new;end

  def create
    # debugger
    teorico = CourseUnit.find_by(id: params[:course][:teorico_id])
    course = Course.find_by(id: teorico.course_id)
    data = {
      person_id: params[:person_id],
      company_id: current_user.company_id,
      manager_id: current_user.person_id,
      operator_id: params[:operator_id], 
      fleet_category_id: params[:fleet_category_id],
      inscription_motive_id: params[:inscription_motive_id], 
    }
    ActiveRecord::Base.transaction do
      course_person_teoria = CoursePerson.new(data)
      course_person_teoria.date = params[:course][:date_teorico],
      course_person_teoria.course_unit_id = params[:course][:teorico_id]
      course_person_teoria.register_renovation

      if !params[:course][:date_practico].blank?
        course_person_practica = CoursePerson.new(data)
        course_person_practica.date = params[:course][:date_practico],
        course_person_practica.course_unit_id = params[:course][:practico_id]
        course_person_practica.register_renovation
      end

      if !params[:course][:date_psicometrico].blank?
        course_person_psicometrico = CoursePerson.new(data)
        course_person_psicometrico.date = params[:course][:date_psicometrico],
        course_person_psicometrico.course_unit_id = params[:course][:psicometrico_id]
        course_person_psicometrico.register_renovation
      end
    end
    rescue ActiveRecord::StatementInvalid
      render turbo_stream: [
            turbo_stream.replace("toasts",
              partial: "shared/toasts",
              locals: { message: "No se pudo realizar la inscripción.", status_class: "danger" })
        ]

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: [
            turbo_stream.replace("toasts",
              partial: "shared/toasts",
              locals: { message: "Inscripción exitosa.", status_class: "primary" })
        ]
      }
      format.html { redirect_to courses_path, notice: "Inscripción exitosa." }
      format.json { render :show, status: :created, location: course_person }
    end
  end
end
