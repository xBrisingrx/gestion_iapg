class ExamModulesController < ApplicationController
  before_action :set_exam_module, only: %i[ show edit update destroy ]

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
    @exam_module = ExamModule.new(exam_module_params)

    respond_to do |format|
      if @exam_module.save
        format.html { redirect_to @exam_module, notice: "Exam module was successfully created." }
        format.json { render :show, status: :created, location: @exam_module }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @exam_module.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exam_modules/1 or /exam_modules/1.json
  def update
    respond_to do |format|
      if @exam_module.update(exam_module_params)
        format.html { redirect_to @exam_module, notice: "Exam module was successfully updated." }
        format.json { render :show, status: :ok, location: @exam_module }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @exam_module.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exam_modules/1 or /exam_modules/1.json
  def destroy
    @exam_module.destroy!

    respond_to do |format|
      format.html { redirect_to exam_modules_path, status: :see_other, notice: "Exam module was successfully destroyed." }
      format.json { head :no_content }
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
