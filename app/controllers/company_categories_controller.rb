class CompanyCategoriesController < ApplicationController
  before_action :set_company_category, only: %i[ show edit update modal_disable disable ]

  # GET /company_categories or /company_categories.json
  def index
    filter = CompanyCategory.filter(params[:query])
    @pagy, @company_categories = pagy(filter)
  end

  # GET /company_categories/1 or /company_categories/1.json
  def show
  end

  # GET /company_categories/new
  def new
    @company_category = CompanyCategory.new
  end

  # GET /company_categories/1/edit
  def edit
  end

  # POST /company_categories or /company_categories.json
  def create
    @company_category = CompanyCategory.new(company_category_params)
    respond_to do |format|
      if @company_category.save
        format.turbo_stream { 
          render turbo_stream: [
            turbo_stream.prepend("tbody_company_categories", 
              partial: "company_categories/company_category", 
              locals: { company_category: @company_category }),
            turbo_stream.replace("toasts", 
              partial: "shared/toasts", 
              locals: { message: 'Categoría registrada', status_class: 'primary' })
          ]
        }
        format.html { redirect_to company_category_url(@company_category), notice: "Categoría registrada." }
        format.json { render :show, status: :created, location: @company_category }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @company_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /company_categories/1 or /company_categories/1.json
  def update
    respond_to do |format|
      if @company_category.update(company_category_params)
        format.turbo_stream { 
          render turbo_stream: [
            turbo_stream.replace(@company_category),
            turbo_stream.replace("toasts", 
              partial: "shared/toasts", 
              locals: { message: 'Categoría actualizada', status_class: 'primary' })
          ]
        }
        format.html { redirect_to @company_category, notice: "Categoría actualizada." }
        format.json { render :show, status: :ok, location: @company_category }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @company_category.errors, status: :unprocessable_entity }
      end
    end
  end

  def modal_disable;end

  def disable
    if @company_category.update(active: false)
        render turbo_stream: [
          turbo_stream.remove(@company_category),
          turbo_stream.replace("toasts",
            partial: "shared/toasts",
            locals: { message: "Categoría dada de baja.", status_class: "primary" })
        ], status: :ok
    else
      render json: @company_category.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company_category
      @company_category = CompanyCategory.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def company_category_params
      params.require(:company_category).permit(:name, :description, :quota)
    end
end
