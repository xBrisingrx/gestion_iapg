FactoryBot.define do
  factory :headquarter do
    name { "MyString" }
    description { "MyString" }
    sectional { nil }
    province { nil }
    city { nil }
    can_make_psychometric { false }
    active { false }
  end
end
