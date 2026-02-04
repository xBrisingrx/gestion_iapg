FactoryBot.define do
  factory :price do
    price { 1 }
    unit { nil }
    client_type { 1 }
    sectional { nil }
    company { nil }
    start_date { "2026-01-20" }
    end_date { "2026-01-20" }
    active { false }
  end
end
