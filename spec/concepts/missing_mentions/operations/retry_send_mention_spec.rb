require 'rails_helper'

describe MissingMentions::Operations::RetrySendMention do
  let(:missing_mention) { create :missing_mention }

  before { stub_create_webhook_subscription }

  it 'send mention' do
    expect(SendMention).to receive(:mention_and_missing).with(missing_mention.activity_subscription,
                                                              missing_mention.subscription, missing_mention.mention)
                                                        .and_return(OpenStruct.new(success?: true))
    MissingMentions::Operations::RetrySendMention.run!(missing_mention: missing_mention)
  end

  it 'dont delete missing_mention if not sent' do
    missing_mention
    allow(SendMention).to receive(:mention_and_missing).and_return(OpenStruct.new(success?: false))
    expect { MissingMentions::Operations::RetrySendMention.run!(missing_mention: missing_mention) }
      .to_not change { MissingMention.count }
  end

  it 'delete missing_mention if was sent' do
    missing_mention
    allow(SendMention).to receive(:mention_and_missing).and_return(OpenStruct.new(success?: true))
    expect { MissingMentions::Operations::RetrySendMention.run!(missing_mention: missing_mention) }
      .to change { MissingMention.count }.from(1).to(0)
  end
end
