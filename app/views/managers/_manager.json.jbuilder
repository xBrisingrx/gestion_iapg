json.extract! manager, :id, :company_id, :person_id, :email, :job, :active, :created_at, :updated_at
json.url manager_url(manager, format: :json)
