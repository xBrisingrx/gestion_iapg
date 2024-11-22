json.extract! course_person, :id, :course_id, :person_id, :company_id, :inscription_motive_id, :fleet_category_id, :unit_id, :course_unit_id, :date, :from_hour, :to_hour, :active, :created_at, :updated_at
json.url course_person_url(course_person, format: :json)
