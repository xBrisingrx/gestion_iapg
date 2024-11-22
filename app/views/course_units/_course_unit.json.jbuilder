json.extract! course_unit, :id, :course_id, :unit_id, :instructor_id, :shift, :day, :start_hour, :end_hour, :date, :shift_time, :list, :created_at, :updated_at
json.url course_unit_url(course_unit, format: :json)
