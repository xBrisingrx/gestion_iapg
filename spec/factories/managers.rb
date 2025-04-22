FactoryBot.define do
  factory :manager do
    company { nil }
    person { nil }
    email { "MyString" }
    job { "MyString" }
    active { false }
  end
end
