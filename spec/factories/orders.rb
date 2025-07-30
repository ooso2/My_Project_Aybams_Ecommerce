FactoryBot.define do
  factory :order do
    user { nil }
    order_number { "MyString" }
    order_date { "2025-07-30 14:18:45" }
    status { "MyString" }
    subtotal { "9.99" }
    tax_amount { "9.99" }
    shipping_cost { "9.99" }
    total_amount { "9.99" }
    shipping_address { "MyText" }
    billing_address { "MyText" }
  end
end
