class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update modal_disable disable register_attendance ]

  # GET /courses or /courses.json
  def index
    @query = Course.ransack(params[:query])
    @pagy, @courses = pagy(@query.result)
    authorize @courses
  end

  # GET /courses/1 or /courses/1.json
  def show
    @course_people = CoursePerson.where(course_id: params[:course_id])
    @units = @course.course_type.units
  end

  # GET /courses/new
  def new
    @course = Course.new
    @course.course_units.build
    authorize @course
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses or /courses.json
  def create
    @course = Course.new(course_params)
    respond_to do |format|
      if @course.save
        format.html { redirect_to courses_path, notice: "Curso registrado." }
        format.json { render json: { status: :success }, status: :created, location: @course }
      else
        # format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors.messages, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to courses_path, notice: "Courso actualizado." }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
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
            locals: { message: "Curso dado de baja.", status_class: "primary" })
        ], status: :ok
    else
      render turbo_stream: [
        turbo_stream.replace("toasts",
          partial: "shared/toasts",
          locals: { message: "No se pudo dar de baja el curso.", status_class: "danger" }) ],
        status: :unprocessable_entity
    end
  end

  def register_attendance
    @course_units = @course.course_units.includes(:unit)
  end

  def scoring
    @course_types = CourseType.select(:id, :name).actives
  end

  def by_course_type
    @courses = Course.where(course_type_id: params[:course_type_id])
  end

  def register_scoring_modal
    @course = Course.find(params[:id])
    @course_person = CoursePerson.where(course_id: params[:id], person_id: params[:person_id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params.expect(:id))
      authorize @course
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.expect(course: [ :from_date, :to_date, :year_number, :general_number, :is_company, :course_type_id, :room_id, :company_id, :code,
        course_units_attributes: [
          [ :id, :instructor_id, :unit_id, :start_hour, :end_hour, :shift, :shift_time, :day, :list ] ],
          course_people_attributes: [
          [ :id, :course_id, :person_id, :scoring, :make_up_1, :date_make_up_1, :make_up_2, :date_make_up_2 ] ]
        ])
    end
end
