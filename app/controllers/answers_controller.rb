class AnswersController < ApplicationController
  before_action :set_answer, only: %i[ show edit update destroy ]

  # GET /answers or /answers.json
  def index
    @question = Question.find_by(id: params[:question_id])
    @answers = @question.answers.actives
  end

  # GET /answers/1 or /answers/1.json
  def show
  end

  # GET /answers/new
  def new
    @answer = Answer.new
  end

  # GET /answers/1/edit
  def edit
  end

  # POST /answers or /answers.json
  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    respond_to do |format|
      if @answer.save
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.append("tbody_answers",
              partial: "answers/answer",
              locals: { answer: @answer }),
            turbo_stream.replace("form_new_answer",
              partial: "answers/form",
              locals: { question: @answer.question, answer: Answer.new }),
            turbo_stream.replace("toasts",
              partial: "shared/toasts",
              locals: { message: "Respuesta registrada", status_class: "primary" })
          ]
        }
        format.html { redirect_to @iva_condition, notice: "Iva condition was successfully created." }
        format.json { render :show, status: :created, location: @iva_condition }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @iva_condition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /answers/1 or /answers/1.json
  def update
    respond_to do |format|
      if @answer.update(answer_params)
        format.html { redirect_to @answer, notice: "Answer was successfully updated." }
        format.json { render :show, status: :ok, location: @answer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /answers/1 or /answers/1.json
  def destroy
    @answer.destroy!

    respond_to do |format|
      format.html { redirect_to answers_path, status: :see_other, notice: "Answer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      @answer = Answer.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def answer_params
      params.expect(answer: [ :answer, :correct, :order, :active, :question_id ])
    end
end
