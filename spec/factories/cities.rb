FactoryBot.define do
  factory :city do
    sequence(:name) { |n| "Comodoro Rivadavia x#{n}" }
    province { association :province }
    active { true }
  end
end
