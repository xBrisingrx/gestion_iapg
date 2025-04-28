json.extract! exam_question, :id, :exam_id, :question_id, :order, :active, :created_at, :updated_at
json.url exam_question_url(exam_question, format: :json)
