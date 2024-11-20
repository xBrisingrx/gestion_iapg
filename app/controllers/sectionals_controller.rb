class SectionalsController < ApplicationController
  before_action :set_sectional, only: %i[ show edit update modal_disable disable ]

  # GET /sectionals or /sectionals.json
  def index
    @query = Sectional.actives.ransack(params[:query])
    @pagy, @sectionals = pagy(@query.result.includes(:city, :province))
    authorize @sectionals
  end

  # GET /sectionals/1 or /sectionals/1.json
  def show
  end

  # GET /sectionals/new
  def new
    @sectional = Sectional.new
    authorize @sectional
  end

  # GET /sectionals/1/edit
  def edit
  end

  # POST /sectionals or /sectionals.json
  def create
    @sectional = Sectional.new(sectional_params)

    respond_to do |format|
      if @sectional.save
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.prepend("tbody_sectionals",
              partial: "sectionals/sectional",
              locals: { sectional: @sectional }),
            turbo_stream.replace("toasts",
              partial: "shared/toasts",
              locals: { message: "Seccional registrada", status_class: "primary" })
          ]
        }
        format.html { redirect_to @sectional, notice: "Sectional was successfully created." }
        format.json { render :show, status: :created, location: @sectional }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sectional.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sectionals/1 or /sectionals/1.json
  def update
    respond_to do |format|
      if @sectional.update(sectional_params)
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace(@sectional),
            turbo_stream.replace("toasts",
              partial: "shared/toasts",
              locals: { message: "Seccional actualizada", status_class: "primary" })
          ]
        }
        format.html { redirect_to @sectional, notice: "Sectional was successfully updated." }
        format.json { render :show, status: :ok, location: @sectional }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sectional.errors, status: :unprocessable_entity }
      end
    end
  end

  def modal_disable;end

  def disable
    if @sectional.update(active: false)
        render turbo_stream: [
          turbo_stream.remove(@sectional),
          turbo_stream.replace("toasts",
            partial: "shared/toasts",
            locals: { message: "Seccional eliminada", status_class: "primary" })
        ], status: :ok
    else
      render json: @sectional.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sectional
      @sectional = Sectional.find(params.expect(:id))
      authorize @sectional
    end

    # Only allow a list of trusted parameters through.
    def sectional_params
      params.expect(sectional: [ :name, :direction, :city_id, :province_id, :active ])
    end
end
