require 'rails_helper'

describe ActivitySubscriptionsController, type: :request do
  before do
    stub_create_webhook_subscription
    stub_delete_webhook_subscription
  end

  let(:access_token) { 'some_access_token' }
  let(:page_id) { '1' }
  let(:words) { %w[some words] }
  let(:campaign_id) { '1' }

  it 'create' do
    prev_count = ActivitySubscription.count
    post('/activity_subscriptions', params: { activity_subscription: { access_token: access_token,
                                                                       page_id: page_id,
                                                                       campaign_id: campaign_id,
                                                                       words: words } },
                                    headers: nil)
    expect(response).to be_success
    expect(ActivitySubscription.count).to eql(prev_count + 1)
    as = ActivitySubscription.last
    expect(as.access_token).to eql(access_token)
    expect(as.page_id).to eql(page_id)
    expect(as.campaign_id).to eql(campaign_id)
    expect(as.words).to eql(words)
    expect(as.hashtags).to eql([])
  end

  it 'destroy' do
    as = create :activity_subscription
    prev_count = ActivitySubscription.count
    delete("/activity_subscriptions/#{as.id}")
    expect(response).to be_success
    expect(ActivitySubscription.count).to eql(prev_count - 1)
  end
end
