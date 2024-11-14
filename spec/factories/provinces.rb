FactoryBot.define do
  factory :province do
    sequence(:name) { |n| "Provincia X #{n}" }
    active { true }
  end
end
