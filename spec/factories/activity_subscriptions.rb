FactoryBot.define do
  factory :activity_subscription do
    access_token { 'some_access_token' }
    page_id { 12345 }
    instagram_business_account_id { 123 }
    words { [] }
    hashtags { [] }
  end
end