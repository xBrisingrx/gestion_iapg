class ExamQuestionsController < ApplicationController
  before_action :set_exam_question, only: %i[ show modal_disable disable ]

  # GET /exam_questions or /exam_questions.json
  def index
    @exam = Exam.find(params[:exam_id])
    @query = @exam.exam_questions.actives.ransack(params[:query])
    @pagy, @exam_questions = pagy(@query.result.order(:question_order))
    exam_questions_ids = @exam.exam_questions.pluck(:question_id)
    @questions = Question.where.not(id: exam_questions_ids)
  end

  # GET /exam_questions/1 or /exam_questions/1.json
  def show
  end

  # GET /exam_questions/new
  def new
    @exam_question = ExamQuestion.new
  end

  # POST /exam_questions or /exam_questions.json
  def create
    @exam = Exam.find(params[:exam_id])
    @exam_question = @exam.exam_questions.new(exam_question_params)
    respond_to do |format|
      if @exam_question.save
        exam_questions_ids = @exam.exam_questions.pluck(:question_id)
        questions = Question.where.not(id: exam_questions_ids)
        exam_questions = @exam.exam_questions.actives
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace("tbody_exam_questions",
              partial: "exam_questions/tbody",
              locals: { exam_questions: exam_questions }),
            turbo_stream.replace("form_new_exam_question",
              partial: "exam_questions/form",
              locals: { exam: @exam, exam_question: ExamQuestion.new, questions: questions }),
            turbo_stream.replace("toasts",
              partial: "shared/toasts",
              locals: { message: "Pregunta registrada", status_class: "primary" })
          ]
        }
        format.html { redirect_to @exam_question, notice: "Exam question was successfully created." }
        format.json { render :show, status: :created, location: @exam_question }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @exam_question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exam_questions/1 or /exam_questions/1.json
  def modal_disable;end

  def disable
    if @exam_question.disable
        render turbo_stream: [
          turbo_stream.remove(@exam_question),
          # turbo_stream.remove("modal"),
          turbo_stream.replace("toasts",
            partial: "shared/toasts",
            locals: { message: "Pregunta desasignada de baja.", status_class: "primary" })
        ], status: :ok
    else
      render turbo_stream: [
        turbo_stream.replace("toasts",
          partial: "shared/toasts",
          locals: { message: "No se pudo desasignadar la pregunta.", status_class: "danger" }) ],
        status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exam_question
      @exam_question = ExamQuestion.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def exam_question_params
      params.expect(exam_question: [ :exam_id, :question_id ])
    end
end
