FactoryBot.define do
  factory :course_type_unit do
    course_type { nil }
    unit { nil }
    day { 1 }
    start_hour { "2024-11-20 14:47:25" }
    end_hour { "2024-11-20 14:47:25" }
    is_by_turn { false }
    shift { "MyString" }
    shift_time { 1 }
  end
end
