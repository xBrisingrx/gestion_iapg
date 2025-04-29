class ModuleVideosController < ApplicationController
  before_action :set_module_video, only: %i[ show edit update destroy ]

  # GET /module_videos or /module_videos.json
  def index
    @query = ModuleVideo.where(exam_module_id: params[:exam_module_id]).actives.ransack(params[:query])
    @pagy, @module_videos = pagy(@query.result.order(:video_order))
    @exam_module = ExamModule.find(params[:exam_module_id])
    videos_ids = @exam_module.module_videos.actives.pluck(:video_id)
    @videos = Video.where.not(id: videos_ids)
    authorize @module_videos
  end

  # GET /module_videos/1 or /module_videos/1.json
  def show
  end

  # GET /module_videos/new
  def new
    @module_video = ModuleVideo.new
    authorize @module_video
  end

  # GET /module_videos/1/edit
  def edit
  end

  # POST /module_videos or /module_videos.json
  def create
    @module_video = ModuleVideo.new(module_video_params)
    exam_module = ExamModule.find(@module_video.exam_module_id)
    videos_ids = exam_module.module_videos.actives.pluck(:video_id)
    videos = Video.where.not(id: videos_ids)
    respond_to do |format|
      if @module_video.save
        module_videos = ModuleVideo.actives.where(exam_module_id: @module_video.exam_module_id)
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace("tbody_module_videos",
              partial: "module_videos/tbody",
              locals: { module_videos: module_videos }),
            turbo_stream.replace("form_new_module_video",
              partial: "module_videos/form",
              locals: { exam_module_id: @module_video.exam_module_id, module_video: ModuleVideo.new, videos: videos }),
            turbo_stream.replace("toasts",
              partial: "shared/toasts",
              locals: { message: "Módulo registrado", status_class: "primary" }),
            turbo_stream.replace("exam_module_#{exam_module.id}",
              partial: "exam_modules/exam_module",
              locals: { exam_module: exam_module })
          ]
        }
        format.html { redirect_to @module_video, notice: "Module video was successfully created." }
        format.json { render :show, status: :created, location: @module_video }
      else
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.replace("form_new_module_video",
              partial: "module_videos/form",
              locals: { exam_module_id: @module_video.exam_module_id, module_video: @module_video, videos: videos })
          ]
        }
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @module_video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /module_videos/1 or /module_videos/1.json
  def update
    respond_to do |format|
      if @module_video.update(module_video_params)
        format.html { redirect_to @module_video, notice: "Module video was successfully updated." }
        format.json { render :show, status: :ok, location: @module_video }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @module_video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /module_videos/1 or /module_videos/1.json
  def destroy
    @module_video.destroy!

    respond_to do |format|
      format.html { redirect_to module_videos_path, status: :see_other, notice: "Module video was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_module_video
      @module_video = ModuleVideo.find(params.expect(:id))
      authorize @module_video
    end

    # Only allow a list of trusted parameters through.
    def module_video_params
      params.expect(module_video: [ :exam_module_id, :video_id, :video_order, :active ])
    end
end
