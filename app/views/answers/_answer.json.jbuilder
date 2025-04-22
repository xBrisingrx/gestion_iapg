json.extract! answer, :id, :answer, :correct, :order, :active, :question_id, :created_at, :updated_at
json.url answer_url(answer, format: :json)
