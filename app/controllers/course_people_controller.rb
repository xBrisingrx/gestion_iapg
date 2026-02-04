class CoursePeopleController < ApplicationController
  before_action :set_course_person, only: %i[ show edit update modal_disable disable ]

  # GET /courses or /courses.json
  def index
    if current_user.admin?
      @query = CoursePerson.actives.by_course(params[:course_id])
    else
      @query = CoursePerson.actives.by_course_and_company(params[:course_id], current_user.company_id)
      # debugger
    end
    @course = Course.find(params[:course_id])
    @pagy, @course_people = pagy(@query)

    if current_user.admin?
      render :index
    else
      render :client_view
    end
  end

  # GET /courses/1 or /courses/1.json
  def show
  end

  # GET /courses/new
  def new
    @course = Course.find(params[:course_id])
    @course_person = CoursePerson.new
    @units = @course.course_units.group(:unit_id)
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses or /courses.json
  def create
    @course = Course.find(params[:course_id])
    @course_person = @course.course_people.new(course_person_params)
    course_type_unit = CourseTypeUnit.where(course_type_id: @course.course_type_id).order(:day).first
    # course_unit = CourseUnit.where(course_id: @course.id, unit_id: course_type_unit.unit_id).order(:day).first
    @course_person.unit_id = course_type_unit.unit_id
    # @course_person.course_unit = course_unit
    @course_person.date = @course.from_date
    respond_to do |format|
      if @course_person.assign_turn
        format.turbo_stream {
          render turbo_stream: [
              turbo_stream.replace("toasts",
                partial: "shared/toasts",
                locals: { message: "Inscripción exitosa.", status_class: "primary" }),
              turbo_stream.append("tbody_course_people",
                partial: "course_people/course_person",
                locals: { course_person: @course_person })
          ]
        }
        format.html { redirect_to courses_path, notice: "Inscripción exitosa." }
        format.json { render :show, status: :created, location: @course_person }
      else
        @units = @course.course_units.group(:unit_id)
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course_person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    respond_to do |format|
      if @course_person.update(course_person_params)
        format.turbo_stream {
          render turbo_stream: [
              turbo_stream.replace("toasts",
                partial: "shared/toasts",
                locals: { message: "Asistencia registrada.", status_class: "primary" })
          ]
        }
        format.html { redirect_to courses_path, notice: "Inscripción actualizada." }
        format.json { render :show, status: :ok, location: @course_person }
      else
        format.turbo_stream {
          render turbo_stream: [
              turbo_stream.replace("toasts",
                partial: "shared/toasts",
                locals: { message: "No se pudo registrar la asistencia.", status_class: "danger" })
          ]
        }
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course_person.errors, status: :unprocessable_entity }
      end
    end
  end

  def modal_disable;end

  def disable
    if @course_person.disable
        render turbo_stream: [
          turbo_stream.remove(@course_person),
          turbo_stream.replace("toasts",
            partial: "shared/toasts",
            locals: { message: "Persona quitada del curso.", status_class: "primary" })
        ], status: :ok
    else
      render turbo_stream: [
        turbo_stream.replace("toasts",
          partial: "shared/toasts",
          locals: { message: "No se pudo quitar a esta persona.", status_class: "danger" }) ],
        status: :unprocessable_entity
    end
  end

  def by_course
    @course_people = CoursePerson.actives.by_course(params[:course_id])
  end

  def show_survey
    course_person = CoursePerson.find(params[:id])
    @name = course_person.person.fullname
    @surveys = Survey.where(person: course_person.person, course: course_person.course)
  end

  def particular_modal
    @course = Course.find(params[:course_id])
    @course_person = CoursePerson.new
    @people = Person.select(:id, :name, :last_name, :cuil).actives
  end

  def register_particular
    @course = Course.find(params[:course_id])
    @course_person = @course.course_people.new(person_id: params[:course_person][:person_id])
    respond_to do |format|
      if @course_person.register_particular
        format.turbo_stream {
          render turbo_stream: [
              turbo_stream.replace("toasts",
                partial: "shared/toasts",
                locals: { message: "Inscripción exitosa.", status_class: "primary" }),
              turbo_stream.append("tbody_course_people",
                partial: "course_people/course_person",
                locals: { course_person: @course_person })
          ]
        }
        format.html { redirect_to courses_path, notice: "Inscripción exitosa." }
        format.json { render :show, status: :created, location: @course_person }
      else
        debugger
        @people = Person.select(:id, :name, :last_name, :cuil).actives
        format.html { render :particular_modal, status: :unprocessable_entity }
        format.json { render json: @course_person.errors, status: :unprocessable_entity }
      end
    end
  end

  def modal_payments_statuses # mostramos un modal con los cursos persona y el estado, es un detalle de items a pagar
    @course_people = CoursePerson.actives.where(course_id: params[:course_id], person_id: params[:person_id])
    @total = @course_people.where(is_free: false).sum(:price)
  end

  def get_pendings
    @course_people = CoursePerson.actives.where(company_id: params[:company_id], pay_status: :no_pay)
    render :pendings_table
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course_person
      @course_person = CoursePerson.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def course_person_params
      params.expect(course_person: [ :course_id, :person_id, :company_id, :manager_id, :operator_id, :inscription_motive_id, :fleet_category_id, :unit_id,
        :course_unit_id, :date, :from_hour, :to_hour, :active, :attendance_status, :practical_turn_id, :psicometrico_turn_id ])
    end
end
