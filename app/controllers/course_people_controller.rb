class CoursePeopleController < ApplicationController
  before_action :set_course_person, only: %i[ show edit update modal_disable disable ]

  # GET /courses or /courses.json
  def index
    @query = CoursePerson.where(course_id: params[:course_id]).includes(:person).group(:person_id).order(people: { last_name: :asc })
    @course = Course.find(params[:course_id])
    @pagy, @course_people = pagy(@query)
  end

  # GET /courses/1 or /courses/1.json
  def show
  end

  # GET /courses/new
  def new
    @course = Course.find(params[:course_id])
    @course_person = CoursePerson.new
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
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course_person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    respond_to do |format|
      if @course_person.update(course_person_params)
        format.html { redirect_to courses_path, notice: "Inscripción actualizada." }
        format.json { render :show, status: :ok, location: @course_person }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course_person.errors, status: :unprocessable_entity }
      end
    end
  end

  def modal_disable;end

  def disable
    if @course.disable
        render turbo_stream: [
          turbo_stream.remove(@course),
          turbo_stream.replace("toasts",
            partial: "shared/toasts",
            locals: { message: "Inscripción dado de baja.", status_class: "primary" })
        ], status: :ok
    else
      render turbo_stream: [
        turbo_stream.replace("toasts",
          partial: "shared/toasts",
          locals: { message: "No se pudo dar de baja la inscripción.", status_class: "danger" }) ],
        status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course_person
      @course_person = CoursePerson.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def course_person_params
      params.expect(course_person: [ :course_id, :person_id, :company_id, :manager_id, :operator_id, :inscription_motive_id, :fleet_category_id, :unit_id,
        :course_unit_id, :date, :from_hour, :to_hour, :active ])
    end
end
