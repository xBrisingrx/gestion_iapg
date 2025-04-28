FactoryBot.define do
  factory :exam do
    title { "MyString" }
    video { false }
    retake { 1 }
    elearning { false }
    active { false }
  end
end
