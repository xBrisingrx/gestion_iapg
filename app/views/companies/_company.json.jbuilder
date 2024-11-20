json.extract! company, :id, :name, :cuit, :direction, :phone, :operator, :comment, :iva_condition_id, :company_category_id, :sector_id, :province_id, :city_id, :active, :created_at, :updated_at
json.url company_url(company, format: :json)
