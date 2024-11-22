json.extract! course, :id, :from_date, :to_date, :year_number, :general_number, :is_company, :course_type_id, :room_id, :company_id, :active, :code, :created_at, :updated_at
json.url course_url(course, format: :json)
