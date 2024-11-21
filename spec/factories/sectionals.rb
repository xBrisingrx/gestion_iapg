FactoryBot.define do
  factory :sectional do
    sequence(:name) { |n| "Seccional n #{n}" }
    direction { "MyString" }
    city { association :city }
    province { association :province }
    active { true }
  end
end
