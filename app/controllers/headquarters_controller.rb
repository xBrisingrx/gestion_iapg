class HeadquartersController < ApplicationController
  before_action :set_headquarter, only: %i[ show edit update modal_disable disable ]

  # GET /headquarters or /headquarters.json
  def index
    @query = Headquarter.ransack(params[:query])
    @pagy, @headquarters = pagy(@query.result)
    authorize @headquarters
  end

  # GET /headquarters/1 or /headquarters/1.json
  def show
  end

  # GET /headquarters/new
  def new
    @headquarter = Headquarter.new
    authorize @headquarter
  end

  # GET /headquarters/1/edit
  def edit;end

  # POST /headquarters or /headquarters.json
  def create
    @headquarter = Headquarter.new(headquarter_params)

    respond_to do |format|
      if @headquarter.save
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.prepend("tbody_headquarters",
              partial: "headquarters/headquarter",
              locals: { headquarter: @headquarter }),
            turbo_stream.replace("toasts",
              partial: "shared/toasts",
              locals: { message: "Sede registrada", status_class: "primary" })
          ]
        }
        format.html { redirect_to @headquarter, notice: "Headquarter was successfully created." }
        format.json { render :show, status: :created, location: @headquarter }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @headquarter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /headquarters/1 or /headquarters/1.json
  def update
    respond_to do |format|
      if @headquarter.update(headquarter_params)
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace(@headquarter),
            turbo_stream.replace("toasts",
              partial: "shared/toasts",
              locals: { message: "Sede actualizada", status_class: "primary" })
          ]
        }
        format.html { redirect_to @headquarter, notice: "Headquarter was successfully updated." }
        format.json { render :show, status: :ok, location: @headquarter }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @headquarter.errors, status: :unprocessable_entity }
      end
    end
  end

  def modal_disable;end

  def disable
    if @headquarter.update(active: false)
        render turbo_stream: [
          turbo_stream.remove(@headquarter),
          turbo_stream.replace("toasts",
            partial: "shared/toasts",
            locals: { message: "Sede eliminada", status_class: "primary" })
        ], status: :ok
    else
      render json: @headquarter.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_headquarter
      @headquarter = Headquarter.find(params.expect(:id))
      authorize @headquarter
    end

    # Only allow a list of trusted parameters through.
    def headquarter_params
      params.expect(headquarter: [ :name, :description, :sectional_id, :province_id, :city_id, :can_make_psychometric ])
    end
end
