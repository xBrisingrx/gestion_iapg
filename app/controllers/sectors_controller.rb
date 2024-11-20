class SectorsController < ApplicationController
  before_action :set_sector, only: %i[ show edit update modal_disable disable ]

  # GET /sectors or /sectors.json
  def index
    filter = Sector.filter(params[:query])
    @pagy, @sectors = pagy(filter)
    authorize @sectors
  end

  # GET /sectors/1 or /sectors/1.json
  def show
  end

  # GET /sectors/new
  def new
    @sector = Sector.new
  end

  # GET /sectors/1/edit
  def edit
  end

  # POST /sectors or /sectors.json
  def create
    @sector = Sector.new(sector_params)

    respond_to do |format|
      if @sector.save
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.prepend("tbody_sectors",
              partial: "sectors/sector",
              locals: { sector: @sector }),
            turbo_stream.replace("toasts",
              partial: "shared/toasts",
              locals: { message: "Rubro registrado", status_class: "primary" })
          ]
        }
        format.html { redirect_to @sector, notice: "Sector was successfully created." }
        format.json { render :show, status: :created, location: @sector }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sector.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sectors/1 or /sectors/1.json
  def update
    respond_to do |format|
      if @sector.update(sector_params)
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace(@sector),
            turbo_stream.replace("toasts",
              partial: "shared/toasts",
              locals: { message: "Rubro actualizado", status_class: "primary" })
          ]
        }
        format.html { redirect_to @sector, notice: "Sector was successfully updated." }
        format.json { render :show, status: :ok, location: @sector }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sector.errors, status: :unprocessable_entity }
      end
    end
  end

  def modal_disable;end

  def disable
    if @sector.update(active: false)
        render turbo_stream: [
          turbo_stream.remove(@sector),
          turbo_stream.replace("toasts",
            partial: "shared/toasts",
            locals: { message: "Rubro eliminado", status_class: "primary" })
        ], status: :ok
    else
      render json: @sector.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sector
      @sector = Sector.find(params.expect(:id))
      authorize @sector
    end

    # Only allow a list of trusted parameters through.
    def sector_params
      params.expect(sector: [ :name, :description ])
    end
end
