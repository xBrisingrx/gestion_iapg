FactoryBot.define do
  factory :turn do
    course { nil }
    person { nil }
    unit { nil }
    course_unit { nil }
    date { "2024-11-22" }
    hour { "2024-11-22 12:28:38" }
    available { false }
    list { 1 }
    status { 1 }
  end
end
