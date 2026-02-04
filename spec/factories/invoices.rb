FactoryBot.define do
  factory :invoice do
    number { "MyString" }
    company { nil }
    status { 1 }
    detail { "MyString" }
    date { "2026-01-27" }
    pay_date { "2026-01-27" }
    active { false }
  end
end
