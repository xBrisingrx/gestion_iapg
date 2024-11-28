class ManagersController < ApplicationController
  before_action :set_manager, only: %i[ show edit update ]

  # GET /managers or /managers.json
  def index
    @managers = Manager.where(company_id: params[:company_id])
  end

  # GET /managers/1 or /managers/1.json
  def show
  end

  # GET /managers/new
  def new
    @manager = Manager.new
  end

  # GET /managers/1/edit
  def edit
  end

  # POST /managers or /managers.json
  def create
    @manager = Manager.new(manager_params)

    respond_to do |format|
      if @manager.save
        format.html { redirect_to @manager, notice: "Manager was successfully created." }
        format.json { render :show, status: :created, location: @manager }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @manager.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /managers/1 or /managers/1.json
  def update
    respond_to do |format|
      if @manager.update(manager_params)
        format.html { redirect_to @manager, notice: "Manager was successfully updated." }
        format.json { render :show, status: :ok, location: @manager }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @manager.errors, status: :unprocessable_entity }
      end
    end
  end

  def get_to_select
    @managers = Manager.where(company_id: params[:company_id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manager
      @manager = Manager.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def manager_params
      params.expect(manager: [ :company_id, :person_id, :email, :job ])
    end
end
