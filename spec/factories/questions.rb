FactoryBot.define do
  factory :question do
    question { "MyString" }
    eliminating { false }
    active { false }
  end
end
