require 'rails_helper'

describe SendMention do
  let!(:subscription) { create :subscription }
  let(:mention) { create :mention }
  let(:activity_subscription) { mention.activity_subscription }

  before { stub_create_webhook_subscription }

  it 'call SendCommentAndMention operation' do
    expect(Subscriptions::Operations::SendCommentAndMention).to receive(:run!)
      .with(raw_data: mention.raw_data,
            campaign_id: activity_subscription.campaign_id,
            owner_username: mention.owner_username,
            endpoint: subscription.hook_url)
      .and_return(OpenStruct.new(success?: true))
    expect { SendMention.execute(activity_subscription, Subscription.all, mention) }
      .to_not change { MissingMention.count }
  end

  it 'creates missing mention if SendCommentAndMention fails' do
    expect(Subscriptions::Operations::SendCommentAndMention).to receive(:run!)
      .and_return(OpenStruct.new(success?: false))
    expect { SendMention.execute(activity_subscription, Subscription.all, mention) }
      .to change { MissingMention.count }.by(1)
  end
end
