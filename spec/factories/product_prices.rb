FactoryBot.define do
  factory :product_price do
    product { nil }
    price { "9.99" }
    currency { "MyString" }
    active { false }
  end
end
