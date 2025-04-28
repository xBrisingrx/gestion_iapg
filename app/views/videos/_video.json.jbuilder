json.extract! video, :id, :title, :file, :vimeo, :code, :active, :created_at, :updated_at
json.url video_url(video, format: :json)
