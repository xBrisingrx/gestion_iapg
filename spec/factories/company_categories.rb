FactoryBot.define do
  factory :company_category do
    sequence(:name) { |n| "Autonomo X#{n}" }
    description { "Monotributista" }
    quota { 1 }
    active { true }

    trait :inactive do
      active { false }
    end
  end
end
