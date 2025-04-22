FactoryBot.define do
  factory :answer do
    answer { "MyString" }
    correct { false }
    order { 1 }
    active { false }
    question { nil }
  end
end
