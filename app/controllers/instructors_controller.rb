class InstructorsController < ApplicationController
  before_action :set_instructor, only: %i[ show edit update modal_disable disable ]

  # GET /instructors or /instructors.json
  def index
    @query = Instructor.ransack(params[:query])
    @pagy, @instructors = pagy(@query.result.includes(:person))
    authorize @instructors
  end

  # GET /instructors/1 or /instructors/1.json
  def show;end

  # GET /instructors/new
  def new
    @instructor = Instructor.new
    authorize @instructor
  end

  # GET /instructors/1/edit
  def edit;end

  # POST /instructors or /instructors.json
  def create
    @instructor = Instructor.new(instructor_params)

    respond_to do |format|
      if @instructor.save
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.prepend("tbody_instructors",
              partial: "instructors/instructor",
              locals: { instructor: @instructor }),
              turbo_stream.replace("toasts",
                partial: "shared/toasts",
                locals: { message: "Instructor registrado con éxito.", status_class: "primary" })
          ]
        }
        format.html { redirect_to @instructor, notice: "Instructor was successfully created." }
        format.json { render :show, status: :created, location: @instructor }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @instructor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /instructors/1 or /instructors/1.json
  def update
    respond_to do |format|
      if @instructor.update(instructor_params)
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace(@instructor,
              partial: "instructors/instructor",
              locals: { instructor: @instructor }),
              turbo_stream.replace("toasts",
                partial: "shared/toasts",
                locals: { message: "Datos actualizados.", status_class: "primary" })
          ]
        }
        format.html { redirect_to @instructor, notice: "Instructor was successfully updated." }
        format.json { render :show, status: :ok, location: @instructor }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @instructor.errors, status: :unprocessable_entity }
      end
    end
  end

  def modal_disable;end

  def disable
    if @instructor.disable
        render turbo_stream: [
          turbo_stream.remove(@instructor),
          turbo_stream.replace("toasts",
            partial: "shared/toasts",
            locals: { message: "Instructor dado de baja.", status_class: "primary" })
        ], status: :ok
    else
      render turbo_stream: [
        turbo_stream.replace("toasts",
          partial: "shared/toasts",
          locals: { message: "No se pudo dar de baja al instructor.", status_class: "danger" }) ],
        status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_instructor
      @instructor = Instructor.find(params.expect(:id))
      authorize @instructor
    end

    # Only allow a list of trusted parameters through.
    def instructor_params
      params.expect(instructor: [ :person_id, :start_date, :end_date, :theoretical, :practical, :code ])
    end
end
