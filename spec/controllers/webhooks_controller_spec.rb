require 'rails_helper'

RSpec.describe WebhooksController, type: :controller do
  let(:activity_subscription) { create :activity_subscription }
  let(:subscription) { create :subscription }
  let(:instagram_business_account_id) { '123' }
  let(:media_id) { '18062598958141247' }
  let(:comment_id) { '17876685787436635' }
  let(:body_media) {
    { object: 'instagram',
      entry: [
        { id: instagram_business_account_id,
          time: 1_568_396_461,
          changes: [
            { value: { media_id: media_id },
              field: 'mentions' }
          ] }
      ],
      webhook: { object: 'instagram', entry: [
        { id: instagram_business_account_id,
          time: 1_568_396_461,
          changes: [
            { value: { media_id: media_id },
              field: 'mentions' }
          ] }
      ] } }
  }

  let(:body_comment) {
    { object: 'instagram',
      entry: [
        { id: instagram_business_account_id,
          time: 1_568_396_461,
          changes: [
            { value: { media_id: media_id,
                       comment_id: comment_id },
              field: 'mentions' }
          ] }
      ],
      webhook: { object: 'instagram', entry: [
        { id: instagram_business_account_id,
          time: 1_568_396_461,
          changes: [
            { value: { media_id: media_id,
                       comment_id: comment_id },
              field: 'mentions' }
          ] }
      ] } }
  }

  def mock_media_caption
    allow(InstagramGraph::Queries::MediaCaption).to receive(:run!).and_return('Texto de prueba')
  end

  def mock_send_comments_and_mentions
    allow(Subscriptions::Operations::SendCommentAndMention).to receive(:run!)
  end

  before(:each) do
    stub_create_webhook_subscription
    activity_subscription
  end

  it 'asks for caption when the event is a media mention' do
    expect(InstagramGraph::Queries::MediaCaption).to receive(:run!)
      .with(instagram_business_account_id: instagram_business_account_id, media_id: media_id,
            access_token: activity_subscription.access_token).and_return('Texto de prueba')
    post :event, params: body_media
    expect(response).to be_success
  end

  it 'asks for text when the event is a comment mention' do
    expect(InstagramGraph::Queries::CommentText).to receive(:run!)
      .with(instagram_business_account_id: instagram_business_account_id, comment_id: comment_id,
            access_token: activity_subscription.access_token).and_return('Texto de prueba')

    post :event, params: body_comment

    expect(response).to be_success
  end

  it 'send mention to subscribed app' do
    subscription
    mock_media_caption
    expect(Subscriptions::Operations::SendCommentAndMention).to receive(:run!)
      .with(campaign_id: activity_subscription.campaign_id,
            endpoint: subscription.hook_url, raw_data: anything)
    post :event, params: body_media
  end

  it 'creates a mention' do
    subscription
    mock_media_caption
    mock_send_comments_and_mentions
    expect { post :event, params: body_media }.to change(Mention, :count).by(1)
    new_mention = Mention.last
    expect(new_mention.field_type).to eql('mentions')
    expect(new_mention.activity_subscription_ids).to eql([activity_subscription.id])
  end
end
