FactoryBot.define do
  factory :product do
    name { "MyString" }
    description { "MyText" }
    current_price { "9.99" }
    stock_quantity { 1 }
    category { nil }
    sku { "MyString" }
    weight { "9.99" }
    dimensions { "MyString" }
    is_active { false }
  end
end
