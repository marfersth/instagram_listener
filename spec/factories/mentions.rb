FactoryBot.define do
  factory :mention do
    raw_data { { key: 'value' } }
    field_type { 'mentions' }
    activity_subscription { create :activity_subscription }
    text { 'some text' }
    owner_username { 'instagram_username' }
  end
end
