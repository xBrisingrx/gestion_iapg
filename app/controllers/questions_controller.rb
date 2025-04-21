class QuestionsController < ApplicationController
  before_action :set_question, only: %i[ show edit update modal_disable disable ]

  # GET /questions or /questions.json
  def index
    filter = Question.filter(params[:query])
    @pagy, @questions = pagy(filter)
    authorize @questions
  end

  # GET /questions/1 or /questions/1.json
  def show
  end

  # GET /questions/new
  def new
    @question = Question.new
    authorize @question
  end

  # GET /questions/1/edit
  def edit
  end

  # POST /questions or /questions.json
  def create
    @question = Question.new(question_params)

    respond_to do |format|
      if @question.save
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.prepend("tbody_questions",
              partial: "questions/question",
              locals: { question: @question }),
            turbo_stream.replace("toasts",
              partial: "shared/toasts",
              locals: { message: "Pregunta registrada", status_class: "primary" })
          ]
        }
        format.html { redirect_to @question, notice: "Iva condition was successfully created." }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questions/1 or /questions/1.json
  def update
    respond_to do |format|
      if @question.update(question_params)
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace(@question),
            turbo_stream.replace("toasts",
              partial: "shared/toasts",
              locals: { message: "Pregunta actualizada", status_class: "primary" })
          ]
        }
        format.html { redirect_to @question, notice: "Iva condition was successfully updated." }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  def modal_disable;end

  def disable
    if @question.update(active: false)
        render turbo_stream: [
          turbo_stream.remove(@question),
          turbo_stream.replace("toasts",
            partial: "shared/toasts",
            locals: { message: "Pregunta eliminada", status_class: "primary" })
        ], status: :ok
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params.expect(:id))
      authorize @question
    end

    # Only allow a list of trusted parameters through.
    def question_params
      params.expect(question: [ :question, :eliminating, :image, :active ])
    end
end
