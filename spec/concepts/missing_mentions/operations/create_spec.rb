require 'rails_helper'

describe MissingMentions::Operations::Create do
  let(:mention) { create :mention }
  let(:activity_subscription) { mention.activity_subscription }
  let(:subscription) { create :subscription }
  let(:missing_mention) { create :missing_mention }

  before { stub_create_webhook_subscription }

  it 'creates a new missing_mention if not exists' do
    expect {
      MissingMentions::Operations::Create.run!(activity_subscription: activity_subscription,
                                               mention: mention,
                                               subscription: subscription)
    }
      .to change { MissingMention.count }.by(1)
  end

  it 'not creates a new missing mention if already exists' do
    missing_mention
    expect {
      MissingMentions::Operations::Create.run!(
        activity_subscription: missing_mention.activity_subscription,
        mention: missing_mention.mention,
        subscription: missing_mention.subscription
      )
    }
      .to_not change { MissingMention.count }
  end
end
