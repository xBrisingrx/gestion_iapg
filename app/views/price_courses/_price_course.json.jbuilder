json.extract! price_course, :id, :price, :course_type_id, :start_date, :end_date, :active, :created_at, :updated_at
json.url price_course_url(price_course, format: :json)
