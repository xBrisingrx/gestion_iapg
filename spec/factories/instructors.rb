FactoryBot.define do
  factory :instructor do
    person { nil }
    start_date { "2024-11-20" }
    end_date { "2024-11-20" }
    theoretical { false }
    practical { false }
    code { "MyString" }
  end
end
