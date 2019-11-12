FactoryBot.define do
  factory :mention do
    raw_data { { key: 'value' } }
    field_type { 'mentions' }
    activity_subscription { create :activity_subscription }
    text { 'some text' }
  end
end
