FactoryBot.define do
  factory :course_type do
    name { "MyString" }
    description { "MyString" }
    min_quota { 1 }
    max_quota { 1 }
    min_score { 1 }
    max_score { 1 }
    passing_score { 1 }
    number_of_repeat { 1 }
    room { nil }
    active { false }
    category { "MyString" }
  end
end
