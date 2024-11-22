FactoryBot.define do
  factory :course_person do
    course { nil }
    person { nil }
    company { nil }
    inscription_motive { nil }
    fleet_category { nil }
    unit { nil }
    course_unit { nil }
    date { "2024-11-22" }
    from_hour { "2024-11-22 12:23:35" }
    to_hour { "2024-11-22 12:23:35" }
    active { false }
  end
end
