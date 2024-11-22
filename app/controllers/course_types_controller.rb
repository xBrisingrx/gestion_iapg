class CourseTypesController < ApplicationController
  before_action :set_course_type, only: %i[ show edit update modal_disable disable get_yearly_and_general_number ]

  # GET /course_types or /course_types.json
  def index
    @query = CourseType.actives.ransack(params[:query])
    @pagy, @course_types = pagy(@query.result.includes(:room))
    authorize @course_types
  end

  # GET /course_types/1 or /course_types/1.json
  def show
    @course_type_units = @course_type.course_type_units.order(:day).order(:unit_id).order(:shift)
  end

  # GET /course_types/new
  def new
    @course_type = CourseType.new
    authorize @course_type
  end

  # GET /course_types/1/edit
  def edit;end

  # POST /course_types or /course_types.json
  def create
    @course_type = CourseType.new(course_type_params)

    respond_to do |format|
      if @course_type.save
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.prepend("tbody_course_types",
              partial: "course_types/course_type",
              locals: { course_type: @course_type }),
              turbo_stream.replace("toasts",
                partial: "shared/toasts",
                locals: { message: "Tipo de curso registrado con éxito.", status_class: "primary" })
          ]
        }
        format.html { redirect_to @course_type, notice: "Course type was successfully created." }
        format.json { render :show, status: :created, location: @course_type }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /course_types/1 or /course_types/1.json
  def update
    respond_to do |format|
      if @course_type.update(course_type_params)
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace(@course_type,
              partial: "course_types/course_type",
              locals: { course_type: @course_type }),
              turbo_stream.replace("toasts",
                partial: "shared/toasts",
                locals: { message: "Datos actulizados.", status_class: "primary" })
          ]
        }
        format.html { redirect_to @course_type, notice: "Course type was successfully updated." }
        format.json { render :show, status: :ok, location: @course_type }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def modal_disable;end

  def disable
    if @course_type.disable
        render turbo_stream: [
          turbo_stream.remove(@course_type),
          turbo_stream.replace("toasts",
            partial: "shared/toasts",
            locals: { message: "Tipo de curso dado de baja.", status_class: "primary" })
        ], status: :ok
    else
      render turbo_stream: [
        turbo_stream.replace("toasts",
          partial: "shared/toasts",
          locals: { message: "No se pudo dar de baja a el tipo de curso.", status_class: "danger" }) ],
        status: :unprocessable_entity
    end
  end

  def get_yearly_and_general_number
    render json: { yearly: @course_type.count_yearly_number, general: @course_type.courses.actives.count }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course_type
      @course_type = CourseType.find(params.expect(:id))
      authorize @course_type
    end

    # Only allow a list of trusted parameters through.
    def course_type_params
      params.expect(course_type: [ :name, :description, :min_quota, :max_quota, :min_score, :max_score,
        :passing_score, :number_of_repeat, :room_id, :category, :fleet ])
    end
end
