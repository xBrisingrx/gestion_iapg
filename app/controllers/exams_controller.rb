class ExamsController < ApplicationController
  before_action :set_exam, only: %i[ show edit update modal_disable disable ]

  # GET /exams or /exams.json
  def index
    @query = Exam.actives.ransack(params[:query])
    @pagy, @exams = pagy(@query.result)
    authorize @exams
  end

  # GET /exams/1 or /exams/1.json
  def show
  end

  # GET /exams/new
  def new
    @exam = Exam.new
    authorize @exam
  end

  # GET /exams/1/edit
  def edit
  end

  # POST /exams or /exams.json
  def create
    @exam = Exam.new(exam_params)

    respond_to do |format|
      if @exam.save
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.prepend("tbody_exams",
              partial: "exams/exam",
              locals: { exam: @exam }),
              turbo_stream.replace("toasts",
                partial: "shared/toasts",
                locals: { message: "Exámen registrado con éxito.", status_class: "primary" })
          ]
        }
        format.html { redirect_to @exam, notice: "Exam was successfully created." }
        format.json { render :show, status: :created, location: @exam }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @exam.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exams/1 or /exams/1.json
  def update
    respond_to do |format|
      if @exam.update(exam_params)
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace(@exam,
              partial: "exams/exam",
              locals: { exam: @exam }),
              turbo_stream.replace("toasts",
                partial: "shared/toasts",
                locals: { message: "Datos actualizados.", status_class: "primary" })
          ]
        }
        format.html { redirect_to @exam, notice: "Exam was successfully updated." }
        format.json { render :show, status: :ok, location: @exam }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @exam.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exams/1 or /exams/1.json
  def modal_disable;end

  def disable
    if @exam.disable
        render turbo_stream: [
          turbo_stream.remove(@exam),
          turbo_stream.replace("toasts",
            partial: "shared/toasts",
            locals: { message: "Exámen dado de baja.", status_class: "primary" })
        ], status: :ok
    else
      render turbo_stream: [
        turbo_stream.replace("toasts",
          partial: "shared/toasts",
          locals: { message: "No se pudo dar de baja al exámen.", status_class: "danger" }) ],
        status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exam
      @exam = Exam.find(params.expect(:id))
      authorize @exam
    end

    # Only allow a list of trusted parameters through.
    def exam_params
      params.expect(exam: [ :title, :exam, :retake, :elearning, :active ])
    end
end
