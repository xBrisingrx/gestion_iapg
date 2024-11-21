FactoryBot.define do
  factory :course_type_unit do
    course_type { association :course_type }
    unit { association :unit }
    day { 1 }
    start_hour { "2024-11-20 8:00:00" }
    end_hour { "2024-11-20 15:30:00" }
    is_by_turn { false }
    shift { "MyString" }
    shift_time { 1 }

    trait :overlapping_hour do
      start_hour { "2024-11-20 13:00:00" }
      end_hour { "2024-11-20 14:00:0" }
    end
  end
end
