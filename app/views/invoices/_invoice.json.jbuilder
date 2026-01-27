json.extract! invoice, :id, :number, :company_id, :status, :detail, :date, :pay_date, :active, :created_at, :updated_at
json.url invoice_url(invoice, format: :json)
