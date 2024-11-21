FactoryBot.define do
  factory :room do
    sequence(:name) { |n| "Sala n #{n}" }
    description { "MyString" }
    capacity { 1 }
    headquarter { association :headquarter }
    active { true }
  end
end
