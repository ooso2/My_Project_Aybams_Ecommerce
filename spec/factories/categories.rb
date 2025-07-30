FactoryBot.define do
  factory :category do
    name { "MyString" }
    description { "MyText" }
    slug { "MyString" }
    parent_id { 1 }
  end
end
