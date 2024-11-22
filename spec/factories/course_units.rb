FactoryBot.define do
  factory :course_unit do
    course { nil }
    unit { nil }
    instructor { nil }
    shift { "MyString" }
    day { 1 }
    start_hour { "2024-11-22 11:46:52" }
    end_hour { "2024-11-22 11:46:52" }
    date { "2024-11-22" }
    shift_time { 1 }
    list { 1 }
  end
end
