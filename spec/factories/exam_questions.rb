FactoryBot.define do
  factory :exam_question do
    exam { nil }
    question { nil }
    order { "MyString" }
    active { false }
  end
end
