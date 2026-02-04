class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update modal_disable disable register_attendance ]

  # GET /courses or /courses.json
  def index
    if current_user.admin?
      @query = Course.ransack(params[:query])
      @pagy, @courses = pagy(@query.result)
      authorize @courses
    else
      redirect_to clients_courses_path
    end
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
    @course.course_exams.build
    @exams = Exam.actives.order(:title)
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
        CoursePerson.check_approved(params[:course][:course_people_attributes]["0"][:id])
        format.turbo_stream {
          render turbo_stream: [
              turbo_stream.replace("toasts",
                partial: "shared/toasts",
                locals: { message: "Nota registrada con éxito.", status_class: "primary" })
          ]
        }
      else
        debugger
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
    @course_units = @course.course_units.group(:unit_id).includes(:unit)
  end

  def scoring
    @course_types = CourseType.select(:id, :name).actives.order(:name)
  end

  def by_course_type
    @courses = Course.where(course_type_id: params[:course_type_id])
  end

  def register_scoring_modal
    @course = Course.find(params[:id])
    @person = Person.find(params[:person_id])
    @course_person = CoursePerson.where(course_id: params[:id], person_id: params[:person_id])
  end

  def by_course_category_and_fleet
    # obtenemos los cursos teoricos filtrando por categoria [inicio/renovacion] y flota [liviano/pesado]
    @course_category = params[:course_category]
    @fleet = params[:fleet]
    # obtengo las unidades teoricas
    units = Unit.where(category: "Teorico").pluck(:id)
    # filtro los cursos que tengan esas unidades y que inicien a partir del dia de la fecha
    courses_ids = CourseUnit.where(unit_id: units).where("date >= ?", Date.today).pluck(:course_id)
    @courses = CourseUnit.where(unit_id: units).where("date >= ?", Date.today).order(:date)
    # de esta forma obtenemos los cursos que tienen unidades teoricas
    @courses2 = Course.joins(:course_type)
                .where(id: courses_ids)
                .where("from_date >= ?", Date.today)
                .where(course_types: { category: params[:course_category], fleet: params[:fleet].to_sym })
                .or(Course.joins(:course_type)
                      .where(course_types: { category: params[:course_category], fleet: :both }))
  end

  def get_teoricos_by_category
    # obtenemos cursos teoricos filtrando por categoria [inicio/renovacion]
    units = Unit.where(category: "Teorico").pluck(:id)
    courses_ids = CourseUnit.where(unit_id: units).pluck(:course_id)
    # @courses = CourseUnit.where(unit_id: units).where("date >= ?", Date.today).order(:date)
    @courses = Course.joins(:course_type)
                .joins(:course_units)
                .joins(:room)
                .joins(course_units: :unit)
                .where(id: courses_ids)
                # .where("from_date >= ?", Date.today)
                .where(course_types: { category: params[:course_category] })
                .where(course_units: { unit_id: units })
                .where(is_company: false)
                .select("courses.id, courses.room_id, courses.from_date, course_units.id as course_unit_id, rooms.name as room_name, units.name as unit_name")
                .order(date: :desc)
  end

  def get_teoricos_in_company
    # obtenemos cursos teoricos filtrando por categoria [inicio/renovacion] que son incompany
    units = Unit.where(category: "Teorico").pluck(:id)
    courses_ids = CourseUnit.where(unit_id: units).pluck(:course_id)
    @courses = Course.joins(:course_type)
                .joins(:course_units)
                .joins(:room)
                .joins(course_units: :unit)
                .where(id: courses_ids)
                # .where("from_date >= ?", Date.today)
                .where(course_types: { category: params[:course_category] })
                .where(course_units: { unit_id: units })
                .where(is_company: true, company_id: params[:company_id])
                .select("courses.id, courses.room_id, courses.from_date, course_units.id as course_unit_id, rooms.name as room_name, units.name as unit_name")
                .order(:date)
    render :get_teoricos_by_category
  end

  def get_cursos_practicos
    # si la modulo de teoria seleccionada pertenece a un curso que tiene modulo de practica de tipo de flota seleccionado
    # se llama solo a ese curso, caso contrario a todos a partir del dia
    # siguiente del modulo de teoria
    course = Course.find(params[:course_id])
    curso_tiene_practica = !course.units.where(units: { category: "Practico", fleet: params[:fleet] }).blank?
    if curso_tiene_practica
       @courses = CourseUnit.joins(:unit).where(course_id: course.id).where(units: { category: "Practico" }).group(:course_id)
       @course_unit_id = @courses.first.id
    else
      @courses = CourseUnit
                  .joins(:unit)
                  .joins(:course)
                  .where("date >= ?", course.from_date)
                  .where(units: { category: "Practico", fleet: params[:fleet] })
                  .where(courses: { is_company: false })
                  .order(:date)
                  .group(:course_id)
    end
    # @course_category = params[:course_category]
    # @fleet = params[:fleet]
    # units = Unit.where(category: "Practico").pluck(:id)
    # @courses = CourseUnit.where(unit_id: units).where("date >= ?", params[:date]).order(:date).group(:course_id)
  end

  def get_psicometricos
    # si la modulo de teoria seleccionada pertenece a un curso que tiene modulo de psicometrico
    # se llama solo a ese curso, caso contrario a todos a partir del dia
    # siguiente del modulo de teoria
    course = Course.find(params[:course_id])
    curso_tiene_psicometrico = !course.units.where(units: { category: "Psicometrico" }).blank?
    if curso_tiene_psicometrico
       @courses = CourseUnit.joins(:unit).where(course_id: course.id).where(units: { category: "Psicometrico" }).group(:course_id)
       @course_unit_id = @courses.first.id
    else
      @courses = CourseUnit
                  .joins(:unit)
                  .joins(:course)
                  .where("date >= ?", course.from_date)
                  .where(units: { category: "Psicometrico" })
                  .where(courses: { is_company: false })
                  .order(:date)
                  .group(:course_id)
    end
    # units = Unit.where(category: "Psicometrico").pluck(:id)
    # @courses = CourseUnit.where(unit_id: units).where("date >= ?", params[:date]).order(:date).group(:course_id)
  end

  def turns
    @course = Course.find(params[:id])
    @days = @course.cant_days
    @turns = @course.turns
    @units = @course.units.group(:name).pluck(:id, :name)
    @units_collection = @course.units.group(:name).select(:id, :name)
    @course_units = @course.course_units
    @available_turns = @course.turns.where(status: :available).select(:id, :hour)
    @tab_active = ""
  end

  def turns_by_unit
    @query = @course.course_people.where(course_unit_id: params[:course_unit_id]).order(:unit_id).order(:from_hour)
    @pagy, @course_people = pagy(@query)
  end

  def change_turn
    turn = Turn.find_by(id: params[:turn_id])
    turn.change_to(params[:change_turn_id])
    @course = Course.find(params[:course_id])
    course_units = @course.course_units
    available_turns = @course.turns.where(status: :available).select(:id, :hour)
    unit_id = CourseUnit.find_by(id: params[:course_unit_id]).unit.id
    @units = @course.units.group(:name).pluck(:id, :name)
    @course_units = @course.course_units
    @available_turns = @course.turns.where(status: :available).select(:id, :hour)
    @tab_active = turn.unit.name
    render turbo_stream: turbo_stream.replace("turns",
      partial: "courses/modal_body_turns_tabs",
      locals: { course_units: course_units, available_turns: available_turns, unit_id: unit_id, list: params[:list].to_i, units: @course.units.group(:name).pluck(:id, :name) })
  end

  def payments
    @query = CoursePerson.ransack(params[:query])
    @pagy, @course_people = pagy(@query.result.group(:course_id, :person_id).includes(:course), limit: 10)
  end

  def modal_files
    @course_id = params[:id]
  end

  def people_registered # descargamos un PDF con el listado de gente anotada en el curso
    course = Course.find(params[:id])
    order_by_column = (params[:category] == "Teorico") ? "last_name" : "from_hour"
    course_people = course.course_people.actives.joins(:unit).joins(:person).where(units: { category: params[:category] }).order("#{order_by_column} ASC")
    pdf = ListadoPdf.new(course, course_people)
    send_data pdf.render,
            filename: "asistencia_#{params[:category]}.pdf".downcase,
            type: "application/pdf",
            disposition: "inline"
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
          [ :id, :course_id, :person_id, :scoring, :make_up_1, :date_make_up_1, :make_up_2, :date_make_up_2 ] ],
          course_exams_attributes: [ [ :fleet, :exam_id, :retake, :num_retake ] ]
        ])
    end
end
