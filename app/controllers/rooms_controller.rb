class RoomsController < ApplicationController
  before_action :set_room, only: %i[ show edit update modal_disable disable ]

  # GET /rooms or /rooms.json
  def index
    @query = Room.ransack(params[:query])
    @pagy, @rooms = pagy(@query.result.includes(:headquarter))
    authorize @rooms
  end

  # GET /rooms/1 or /rooms/1.json
  def show
  end

  # GET /rooms/new
  def new
    @room = Room.new
    authorize @room
  end

  # GET /rooms/1/edit
  def edit;end

  # POST /rooms or /rooms.json
  def create
    @room = Room.new(room_params)

    respond_to do |format|
      if @room.save
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.prepend("tbody_rooms",
              partial: "rooms/room",
              locals: { room: @room }),
            turbo_stream.replace("toasts",
              partial: "shared/toasts",
              locals: { message: "Sala registrada", status_class: "primary" })
          ]
        }
        format.html { redirect_to @room, notice: "Room was successfully created." }
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1 or /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace(@room),
            turbo_stream.replace("toasts",
              partial: "shared/toasts",
              locals: { message: "Sala actualizada", status_class: "primary" })
          ]
        }
        format.html { redirect_to @room, notice: "Room was successfully updated." }
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  def modal_disable;end

  def disable
    if @room.update(active: false)
        render turbo_stream: [
          turbo_stream.remove(@room),
          turbo_stream.replace("toasts",
            partial: "shared/toasts",
            locals: { message: "Sala eliminada", status_class: "primary" })
        ], status: :ok
    else
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params.expect(:id))
      authorize @room
    end

    # Only allow a list of trusted parameters through.
    def room_params
      params.expect(room: [ :name, :description, :capacity, :headquarter_id ])
    end
end
