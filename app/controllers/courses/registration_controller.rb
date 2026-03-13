class Courses::RegistrationController < ApplicationController
  def new
    @course_person = CoursePerson.new
  end

  def create
    course_people = params[:entries]
    ActiveRecord::Base.transaction do
      course_people.map do |course_person|
        cp = CoursePerson.new(course_person.permit(:course_id,
                                                    :person_id,
                                                    :company_id,
                                                    :manager_id,
                                                    :operator_id,
                                                    :inscription_motive_id,
                                                    :fleet_category_id,
                                                    :unit_id,
                                                    :course_unit_id,
                                                    :date))
        cp.register_renovation
      end
    end # transaction
    render json: { success: true, msg: "Registro exitoso" }, status: :ok

    rescue ActiveRecord::RecordInvalid => e
      render json: { success: false, error: e.message }, status: :unprocessable_entity
  end

  private
  def course_person_params
    params.expect(course_person: [ :course_id, :person_id, :company_id, :manager_id, :operator_id, :inscription_motive_id, :fleet_category_id, :unit_id,
      :course_unit_id, :date, :from_hour, :to_hour, :active, :attendance_status, :practical_turn_id, :psicometrico_turn_id ])
  end
end
