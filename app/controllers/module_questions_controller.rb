class ModuleQuestionsController < ApplicationController
  before_action :set_module_question, only: %i[ show edit update destroy ]

  # GET /module_questions or /module_questions.json
  def index
    @query = ModuleQuestion.where(exam_module_id: params[:exam_module_id]).actives.ransack(params[:query])
    @pagy, @module_questions = pagy(@query.result.order(:question_order))
    @exam_module = ExamModule.find(params[:exam_module_id])
    questions_ids = @exam_module.module_questions.actives.pluck(:question_id)
    @questions = Question.where.not(id: questions_ids)
    authorize @module_questions
  end

  # GET /module_questions/1 or /module_questions/1.json
  def show
  end

  # GET /module_questions/new
  def new
    @module_question = ModuleQuestion.new
    authorize @module_question
  end

  # GET /module_questions/1/edit
  def edit
  end

  # POST /module_questions or /module_questions.json
  def create
    @module_question = ModuleQuestion.new(module_question_params)
    exam_module = ExamModule.find(@module_question.exam_module_id)
    questions_ids = exam_module.module_questions.actives.pluck(:question_id)
    questions = Question.where.not(id: questions_ids)
    respond_to do |format|
      if @module_question.save
        module_questions = ModuleQuestion.actives.where(exam_module_id: @module_question.exam_module_id)
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace("tbody_module_questions",
              partial: "module_questions/tbody",
              locals: { module_questions: module_questions }),
            turbo_stream.replace("form_new_module_question",
              partial: "module_questions/form",
              locals: { exam_module_id: @module_question.exam_module_id, module_question: ModuleQuestion.new, questions: questions }),
            turbo_stream.replace("toasts",
              partial: "shared/toasts",
              locals: { message: "Módulo registrado", status_class: "primary" }),
            turbo_stream.replace("exam_module_#{exam_module.id}",
              partial: "exam_modules/exam_module",
              locals: { exam_module: exam_module })
          ]
        }
        format.html { redirect_to @module_question, notice: "Module question was successfully created." }
        format.json { render :show, status: :created, location: @module_question }
      else
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace("form_new_module_question",
              partial: "module_questions/form",
              locals: { exam_module_id: @module_question.exam_module_id, module_question: @module_question, questions: questions })
          ]
        }
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @module_question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /module_questions/1 or /module_questions/1.json
  def update
    respond_to do |format|
      if @module_question.update(module_question_params)
        format.html { redirect_to @module_question, notice: "Module question was successfully updated." }
        format.json { render :show, status: :ok, location: @module_question }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @module_question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /module_questions/1 or /module_questions/1.json
  def destroy
    @module_question.destroy!

    respond_to do |format|
      format.html { redirect_to module_questions_path, status: :see_other, notice: "Module question was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_module_question
      @module_question = ModuleQuestion.find(params.expect(:id))
      authorize @module_question
    end

    # Only allow a list of trusted parameters through.
    def module_question_params
      params.expect(module_question: [ :exam_module_id, :question_id, :question_order, :active ])
    end
end
