require 'rails_helper'

RSpec.describe WebhooksController, type: :controller do
  let(:activity_subscription) { create :activity_subscription, words: ['texto'], hashtags: ['prueba'] }
  let(:activity_subscription_2) { create :activity_subscription, words: ['de'], hashtags: ['prueba'] }
  let(:media_comment_data) do
    { text: 'Texto de #prueba',
      username: '@text_owner',
      media: { id: '123', caption: nil, media_type: 'IMAGE', media_url: 'url',
               children: nil, permalink: 'permalink', comments_count: 1 } }
  end
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
    allow(InstagramGraph::Queries::MediaCaption).to receive(:run!).and_return(media_comment_data)
  end

  def mock_comment_caption
    allow(InstagramGraph::Queries::CommentText).to receive(:run!).and_return(media_comment_data)
  end

  def mock_send_comments_and_mentions
    allow(Subscriptions::Operations::SendCommentAndMention).to receive(:run!).and_return(OpenStruct.new(success?: true))
  end

  before(:each) do
    stub_create_webhook_subscription
    activity_subscription
  end

  it 'asks for caption when the event is a media mention' do
    expect(InstagramGraph::Queries::MediaCaption).to receive(:run!)
      .with(instagram_business_account_id: instagram_business_account_id, media_id: media_id,
            access_token: activity_subscription.access_token,
            fields: 'id,media_type,comments_count,permalink,media_url,like_count,caption,'\
'children{id,media_type,media_url,permalink}').and_return(media_comment_data)

    post :event, params: body_media
    expect(response).to be_success
  end

  it 'asks for text when the event is a comment mention' do
    expect(InstagramGraph::Queries::CommentText).to receive(:run!)
      .with(instagram_business_account_id: instagram_business_account_id, comment_id: comment_id,
            access_token: activity_subscription.access_token,
            fields: 'id,media_type,comments_count,permalink,media_url,like_count,caption,'\
'children{id,media_type,media_url,permalink}').and_return(media_comment_data)

    post :event, params: body_comment

    expect(response).to be_success
  end

  context 'when subscription is present' do
    before do
      subscription
      mock_media_caption
    end

    it 'send mention to subscribed app' do
      expect(Subscriptions::Operations::SendCommentAndMention).to receive(:run!)
        .with(campaign_id: activity_subscription.campaign_id, owner_username: media_comment_data[:username],
              endpoint: subscription.hook_url, raw_data: anything).and_return(OpenStruct.new(success?: true))
      post :event, params: body_media
    end

    it 'send one mention to subscribed app per activity_subscription that matchs' do
      activity_subscription
      activity_subscription_2
      expect(Subscriptions::Operations::SendCommentAndMention).to receive(:run!)
        .twice.and_return(OpenStruct.new(success?: true))
      post :event, params: body_media
    end

    it 'creates a mention' do
      mock_send_comments_and_mentions
      expect { post :event, params: body_media }.to change(Mention, :count).by(1)
      new_mention = Mention.last
      expect(new_mention.field_type).to eql('mentions')
      expect(new_mention.activity_subscription_id).to eql(activity_subscription.id)
      expect(JSON.parse(new_mention.raw_data).keys).to contain_exactly('id', 'media_type', 'comments_count',
                                                                       'permalink', 'media_url',
                                                                       'children', 'caption', 'media_id',
                                                                       'instagram_business_account_id', 'comment_id',
                                                                       'comment_text')
    end

    it 'creates one mentions per activity_subscription that matchs' do
      mock_send_comments_and_mentions
      activity_subscription
      activity_subscription_2
      expect { post :event, params: body_media }.to change(Mention, :count).by(2)
    end

    it 'send correct params to text matcher' do
      mock_send_comments_and_mentions
      expect(Webhooks::Operations::MatchText).to receive(:run!).with(text_to_match: 'Texto de #prueba',
                                                                     words: ['texto'], hashtags: ['prueba'])
      post :event, params: body_media
    end
  end
end
