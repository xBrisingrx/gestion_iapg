json.extract! company_manager, :id, :company_id, :person_id, :email, :job, :notifications, :active, :created_at, :updated_at
json.url company_manager_url(company_manager, format: :json)
