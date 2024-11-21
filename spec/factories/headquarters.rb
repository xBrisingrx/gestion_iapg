FactoryBot.define do
  factory :headquarter do
    sequence(:name) { |n| "Sede n #{n}" }
    description { "MyString" }
    sectional { association :sectional }
    province { nil }
    city { nil }
    can_make_psychometric { false }
    active { false }
  end
end
