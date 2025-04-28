FactoryBot.define do
  factory :exam_module do
    exam { nil }
    name { "MyString" }
    quote_type { "MyString" }
    module_order { 1 }
  end
end
