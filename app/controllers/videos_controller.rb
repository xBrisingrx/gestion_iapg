class VideosController < ApplicationController
  before_action :set_video, only: %i[ show edit update modal_disable disable ]

  # GET /videos or /videos.json
  def index
    @query = Video.actives.ransack(params[:query])
    @pagy, @videos = pagy(@query.result)
    authorize @videos
  end

  # GET /videos/1 or /videos/1.json
  def show
  end

  # GET /videos/new
  def new
    @video = Video.new
    authorize @video
  end

  # GET /videos/1/edit
  def edit
  end

  # POST /videos or /videos.json
  def create
    @video = Video.new(video_params)

    respond_to do |format|
      if @video.save
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.prepend("tbody_videos",
              partial: "videos/video",
              locals: { video: @video }),
              turbo_stream.replace("toasts",
                partial: "shared/toasts",
                locals: { message: "Video registrado con éxito.", status_class: "primary" })
          ]
        }
        format.html { redirect_to @video, notice: "Video was successfully created." }
        format.json { render :show, status: :created, location: @video }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /videos/1 or /videos/1.json
  def update
    respond_to do |format|
      if @video.update(video_params)
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace(@video,
              partial: "videos/video",
              locals: { video: @video }),
              turbo_stream.replace("toasts",
                partial: "shared/toasts",
                locals: { message: "Datos actualizados.", status_class: "primary" })
          ]
        }
        format.html { redirect_to @video, notice: "Video was successfully updated." }
        format.json { render :show, status: :ok, location: @video }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  def modal_disable;end

  def disable
    if @video.disable
        render turbo_stream: [
          turbo_stream.remove(@video),
          turbo_stream.replace("toasts",
            partial: "shared/toasts",
            locals: { message: "Video dado de baja.", status_class: "primary" })
        ], status: :ok
    else
      render turbo_stream: [
        turbo_stream.replace("toasts",
          partial: "shared/toasts",
          locals: { message: "No se pudo dar de baja al video.", status_class: "danger" }) ],
        status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video
      @video = Video.find(params.expect(:id))
      authorize @video
    end

    # Only allow a list of trusted parameters through.
    def video_params
      params.expect(video: [ :title, :file, :vimeo, :code, :active ])
    end
end
