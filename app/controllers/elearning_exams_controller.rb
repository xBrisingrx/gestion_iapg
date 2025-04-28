class ElearningExamsController < ApplicationController
  # maneja los examenes con modulos , se diferencian por el campo "elearning"
  before_action :set_exam, only: %i[ modal_disable disable ]
  def index
    @query = Exam.where(elearning: true).actives.ransack(params[:query])
    @pagy, @exams = pagy(@query.result)
    authorize @exams
  end

  def new
    @exam = Exam.new
    authorize @exam
  end

  def create
    @exam = Exam.new(title: params[:title])
    @exam.elearning = true
    respond_to do |format|
      if @exam.save
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.prepend("tbody_exams",
              partial: "elearning_exams/exam",
              locals: { exam: @exam }),
              turbo_stream.replace("toasts",
                partial: "shared/toasts",
                locals: { message: "Exámen registrado con éxito.", status_class: "primary" })
          ]
        }
        format.json { render :show, status: :created, location: @exam }
      else
        format.json { render json: @exam.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
  end

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
      params.expect(exam: [ :title, :elearning, :active ])
    end
end
