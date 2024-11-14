json.extract! person, :id, :cuil, :last_name, :name, :birthdate, :phone, :celphone, :email, :direction, :code, :province_id, :city_id, :active, :created_at, :updated_at
json.url person_url(person, format: :json)
