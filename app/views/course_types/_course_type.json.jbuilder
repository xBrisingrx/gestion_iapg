json.extract! course_type, :id, :name, :description, :min_quota, :max_quota, :min_score, :max_score, :passing_score, :number_of_repeat, :room_id, :active, :category, :created_at, :updated_at
json.url course_type_url(course_type, format: :json)
