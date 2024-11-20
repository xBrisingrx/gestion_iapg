class UnitsController < ApplicationController
  before_action :set_unit, only: %i[ show edit update modal_disable disable ]

  # GET /units or /units.json
  def index
    @query = Unit.actives.ransack(params[:query])
    @pagy, @units = pagy(@query.result)
    authorize @units
  end

  # GET /units/1 or /units/1.json
  def show
  end

  # GET /units/new
  def new
    @unit = Unit.new
    authorize @unit
  end

  # GET /units/1/edit
  def edit;end

  # POST /units or /units.json
  def create
    @unit = Unit.new(unit_params)

    respond_to do |format|
      if @unit.save
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.prepend("tbody_units",
              partial: "units/unit",
              locals: { unit: @unit }),
            turbo_stream.replace("toasts",
              partial: "shared/toasts",
              locals: { message: "Módulo registrado", status_class: "primary" })
          ]
        }
        format.html { redirect_to @unit, notice: "Unit was successfully created." }
        format.json { render :show, status: :created, location: @unit }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /units/1 or /units/1.json
  def update
    respond_to do |format|
      if @unit.update(unit_params)
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace(@unit),
            turbo_stream.replace("toasts",
              partial: "shared/toasts",
              locals: { message: "Módulo actualizado", status_class: "primary" })
          ]
        }
        format.html { redirect_to @unit, notice: "Unit was successfully updated." }
        format.json { render :show, status: :ok, location: @unit }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  def modal_disable;end

  def disable
    if @unit.disable
        render turbo_stream: [
          turbo_stream.remove(@unit),
          turbo_stream.replace("toasts",
            partial: "shared/toasts",
            locals: { message: "Módulo dado de baja.", status_class: "primary" })
        ], status: :ok
    else
      render turbo_stream: [
        turbo_stream.replace("toasts",
          partial: "shared/toasts",
          locals: { message: "No se pudo dar de baja el módulo.", status_class: "danger" }) ],
        status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unit
      @unit = Unit.find(params.expect(:id))
      authorize @unit
    end

    # Only allow a list of trusted parameters through.
    def unit_params
      params.expect(unit: [ :name, :description, :fleet, :methodology, :category ])
    end
end
