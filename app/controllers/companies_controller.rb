class CompaniesController < ApplicationController
  before_action :set_company, only: %i[ show edit update modal_disable disable ]

  # GET /companies or /companies.json
  def index
    @query = Company.ransack(params[:query])
    @pagy, @companies = pagy(@query.result.includes(:sector, :company_category))
    authorize @companies
  end

  # GET /companies/1 or /companies/1.json
  def show
  end

  # GET /companies/new
  def new
    @company = Company.new
    authorize @company
  end

  # GET /companies/1/edit
  def edit;end

  # POST /companies or /companies.json
  def create
    @company = Company.new(company_params)

    respond_to do |format|
      if @company.save
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.prepend("tbody_companies",
              partial: "companies/company",
              locals: { company: @company }),
              turbo_stream.replace("toasts",
                partial: "shared/toasts",
                locals: { message: "Empresa registrada con éxito.", status_class: "primary" })
          ]
        }
        format.html { redirect_to @company, notice: "Company was successfully created." }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1 or /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace(@company,
              partial: "companies/company",
              locals: { company: @company }),
              turbo_stream.replace("toasts",
                partial: "shared/toasts",
                locals: { message: "Datos actulizados.", status_class: "primary" })
          ]
        }
        format.html { redirect_to @company, notice: "Company was successfully updated." }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  def modal_disable;end

  def disable
    if @company.disable
        render turbo_stream: [
          turbo_stream.remove(@company),
          turbo_stream.replace("toasts",
            partial: "shared/toasts",
            locals: { message: "Empresa dada de baja.", status_class: "primary" })
        ], status: :ok
    else
      render turbo_stream: [
        turbo_stream.replace("toasts",
          partial: "shared/toasts",
          locals: { message: "No se pudo dar de baja a la empresa.", status_class: "danger" }) ],
        status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params.expect(:id))
      authorize @company
    end

    # Only allow a list of trusted parameters through.
    def company_params
      params.expect(company: [ :name, :cuit, :direction, :phone, :operator, :comment,
        :iva_condition_id, :company_category_id, :sector_id, :province_id, :city_id, :credential_years ])
    end
end
