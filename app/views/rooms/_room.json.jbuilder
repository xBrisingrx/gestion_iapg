json.extract! room, :id, :name, :description, :capacity, :headquarter_id, :active, :created_at, :updated_at
json.url room_url(room, format: :json)
