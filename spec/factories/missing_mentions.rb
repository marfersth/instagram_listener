FactoryBot.define do
  factory :missing_mention do
    activity_subscription { create :activity_subscription }
    mention { create :mention }
    subscription { create :subscription, event: 'comments_and_mentions' }
  end
end
