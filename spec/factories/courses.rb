FactoryBot.define do
  factory :course do
    from_date { "2024-11-22" }
    to_date { "2024-11-22" }
    year_number { 1 }
    general_number { 1 }
    is_company { false }
    course_type { nil }
    room { nil }
    company { nil }
    active { false }
    code { "MyString" }
  end
end
