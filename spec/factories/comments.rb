FactoryBot.define do
  factory :comment do
    id { 1 }
    text { "MyString" }
    post_id { "MyString" }
    raw_data { "MyString" }
    instagram_post_id { "MyString" }
  end
end
