FactoryBot.define do
  factory :room do
    name { "MyString" }
    description { "MyString" }
    capacity { 1 }
    headquarter { nil }
    active { false }
  end
end
