json.extract! instructor, :id, :person_id, :start_date, :end_date, :theoretical, :practical, :code, :created_at, :updated_at
json.url instructor_url(instructor, format: :json)
