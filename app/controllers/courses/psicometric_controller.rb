class Courses::PsicometricController < ApplicationController
  # este controlador lo usamos para registrar a una persona en un psicometrico de forma individual
  # generalmente es cuando desaprobaron o estuvieron ausentes
  require "zip"
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
        inscription_motive_id: course_person.inscription_motive_id,
        is_free: params[:is_free]
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

  def upload_view;end

  def upload_files
    zip = params[:zip_file]

    dir = Rails.root.join("public/uploads/#{SecureRandom.hex}")
    FileUtils.mkdir_p(dir)

    Zip::File.open(zip.path) do |zip_file|
      zip_file.each do |entry|
        next unless entry.name.downcase.match(/\.(pdf)$/i)
        temp = Tempfile.new(binmode: true)
        temp.write(entry.get_input_stream.read)
        temp.rewind

        person = Person.find_by(cuil: entry.name.to_i)
        if !person.blank?
          person.psicometrics.attach(
            io: temp,
            filename: entry.name,
            content_type: Marcel::MimeType.for(entry.name)
          )
          person.update_attendance_status_last_psicometric
        end # if
      end # extract_files
    end # open zip
    respond_to do |format|
      format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace("toasts",
              partial: "shared/toasts",
              locals: { message: "Carga exitosa", status_class: "primary" }),
            turbo_stream.replace("psicometric_form",
              partial: "courses/psicometric/form",)
          ]
        }
      format.html { redirect_to carga_psicometricos_courses_psicometric_index_path,
        notice: "Company was successfully created." }
    end
  end
end
