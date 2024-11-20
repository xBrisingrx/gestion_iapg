FactoryBot.define do
  factory :company do
    name { "MyString" }
    cuit { "MyString" }
    direction { "MyString" }
    phone { "MyString" }
    operator { false }
    comment { "MyString" }
    iva_condition { nil }
    company_category { nil }
    sector { nil }
    province { nil }
    city { nil }
    active { false }
  end
end
