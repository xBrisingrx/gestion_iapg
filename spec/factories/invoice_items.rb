FactoryBot.define do
  factory :invoice_item do
    invoice { nil }
    course_person { nil }
    status { 1 }
    active { false }
  end
end
