class CompanyManagersController < ApplicationController
  before_action :set_company_manager, only: %i[ show edit update ]

  # GET /company_managers or /company_managers.json
  def index
    @company_managers = CompanyManager.all
  end

  # GET /company_managers/1 or /company_managers/1.json
  def show
  end

  # GET /company_managers/new
  def new
    @company_manager = CompanyManager.new
  end

  # GET /company_managers/1/edit
  def edit
  end

  # POST /company_managers or /company_managers.json
  def create
    @company_manager = CompanyManager.new(company_manager_params)

    respond_to do |format|
      if @company_manager.save
        format.html { redirect_to @company_manager, notice: "Company manager was successfully created." }
        format.json { render :show, status: :created, location: @company_manager }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @company_manager.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /company_managers/1 or /company_managers/1.json
  def update
    respond_to do |format|
      if @company_manager.update(company_manager_params)
        format.html { redirect_to @company_manager, notice: "Company manager was successfully updated." }
        format.json { render :show, status: :ok, location: @company_manager }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @company_manager.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /company_managers/1 or /company_managers/1.json
  def get_to_select
    @managers = CompanyManager.select(:id, :person_id).actives.where(company_id: params[:company_id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company_manager
      @company_manager = CompanyManager.find(params.expect(:id)).includes(:person)
    end

    # Only allow a list of trusted parameters through.
    def company_manager_params
      params.expect(company_manager: [ :company_id, :person_id, :email, :job, :notifications, :active ])
    end
end
