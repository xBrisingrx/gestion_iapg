class IvaConditionsController < ApplicationController
  before_action :set_iva_condition, only: %i[ show edit update modal_disable disable ]

  # GET /iva_conditions or /iva_conditions.json
  def index
    filter = IvaCondition.filter(params[:query])
    @pagy, @iva_conditions = pagy(filter)
    authorize @iva_conditions
  end

  # GET /iva_conditions/1 or /iva_conditions/1.json
  def show
  end

  # GET /iva_conditions/new
  def new
    @iva_condition = IvaCondition.new
    authorize @iva_condition
  end

  # GET /iva_conditions/1/edit
  def edit
  end

  # POST /iva_conditions or /iva_conditions.json
  def create
    @iva_condition = IvaCondition.new(iva_condition_params)

    respond_to do |format|
      if @iva_condition.save
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.prepend("tbody_iva_conditions",
              partial: "iva_conditions/iva_condition",
              locals: { iva_condition: @iva_condition }),
            turbo_stream.replace("toasts",
              partial: "shared/toasts",
              locals: { message: "Condición de iva registrada", status_class: "primary" })
          ]
        }
        format.html { redirect_to @iva_condition, notice: "Iva condition was successfully created." }
        format.json { render :show, status: :created, location: @iva_condition }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @iva_condition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /iva_conditions/1 or /iva_conditions/1.json
  def update
    respond_to do |format|
      if @iva_condition.update(iva_condition_params)
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace(@iva_condition),
            turbo_stream.replace("toasts",
              partial: "shared/toasts",
              locals: { message: "Condición de iva actualizada", status_class: "primary" })
          ]
        }
        format.html { redirect_to @iva_condition, notice: "Iva condition was successfully updated." }
        format.json { render :show, status: :ok, location: @iva_condition }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @iva_condition.errors, status: :unprocessable_entity }
      end
    end
  end

  def modal_disable;end

  def disable
    if @iva_condition.update(active: false)
        render turbo_stream: [
          turbo_stream.remove(@iva_condition),
          turbo_stream.replace("toasts",
            partial: "shared/toasts",
            locals: { message: "Condición de iva eliminada", status_class: "primary" })
        ], status: :ok
    else
      render json: @iva_condition.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_iva_condition
      @iva_condition = IvaCondition.find(params.expect(:id))
      authorize @iva_condition
    end

    # Only allow a list of trusted parameters through.
    def iva_condition_params
      params.expect(iva_condition: [ :name, :description ])
    end
end
