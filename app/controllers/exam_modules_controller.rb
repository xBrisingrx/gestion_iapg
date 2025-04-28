class ExamModulesController < ApplicationController
  before_action :set_exam_module, only: %i[ show edit ]
  # estos modulos son para los examenes elearning
  # GET /exam_modules or /exam_modules.json
  def index
    @exam = Exam.find(params[:exam_id])
    @query = @exam.exam_modules.actives.ransack(params[:query])
    @pagy, @exam_modules = pagy(@query.result.order(:module_order))
  end

  # GET /exam_modules/1 or /exam_modules/1.json
  def show
  end

  # GET /exam_modules/new
  def new
    @exam_module = ExamModule.new
  end

  # GET /exam_modules/1/edit
  def edit
  end

  # POST /exam_modules or /exam_modules.json
  def create
    @exam = Exam.find(params[:exam_id])
    @exam_module = @exam.exam_modules.new(exam_module_params)
    respond_to do |format|
      if @exam_module.save
        exam_modules = @exam.exam_modules.actives
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace("tbody_exam_modules",
              partial: "exam_modules/tbody",
              locals: { exam_modules: exam_modules }),
            turbo_stream.replace("form_new_exam_module",
              partial: "exam_modules/form",
              locals: { exam: @exam_module.exam, exam_module: ExamModule.new }),
            turbo_stream.replace("toasts",
              partial: "shared/toasts",
              locals: { message: "Módulo registrado", status_class: "primary" })
          ]
        }
        format.json { render :show, status: :created, location: @iva_condition }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @iva_condition.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exam_module
      @exam_module = ExamModule.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def exam_module_params
      params.expect(exam_module: [ :exam_id, :name, :quote_type, :module_order ])
    end
end
