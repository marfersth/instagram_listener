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
  let(:rule_id) { '2' }
  let(:json_response) do
    {
      words: %w[some words],
      hashtags: [],
      rule_id: '2',
      access_token: 'some_access_token',
      page_id: '1',
      campaign_id: '1',
      instagram_business_account_id: '1'
    }
  end

  describe '#create' do
    subject do
      lambda do
        post('/activity_subscriptions', params: { activity_subscription: { access_token: access_token,
                                                                           page_id: page_id,
                                                                           campaign_id: campaign_id,
                                                                           rule_id: rule_id,
                                                                           words: words } },
                                        headers: nil)
      end
    end

    it 'check new instance created' do
      subject.call
      expect(response).to be_success
      as = ActivitySubscription.find(JSON.parse(response.body)['_id'])
      expect(as.attributes.to_json).to include_json(json_response)
    end

    context 'when there isnt activity_subscriptions with that rule_id' do
      it 'creates a new instance of activity_subscriptions' do
        prev_count = ActivitySubscription.count
        subject.call
        expect(ActivitySubscription.count).to eql(prev_count + 1)
      end
    end
    context 'when there isnt activity_subscriptions with that rule_id' do
      it 'updates the instance of activity_subscriptions' do
        create :activity_subscription, rule_id: rule_id
        prev_count = ActivitySubscription.count
        subject.call
        as = ActivitySubscription.find(JSON.parse(response.body)['_id'])
        expect(as.attributes.to_json).to include_json(json_response)
        expect(ActivitySubscription.count).to eql(prev_count)
      end
    end
  end

  describe '#destroy' do
    it 'successfully removes activity_subscription' do
      as = create :activity_subscription
      prev_count = ActivitySubscription.count
      delete("/activity_subscriptions/#{as.campaign_id}")
      expect(response).to be_success
      expect(ActivitySubscription.count).to eql(prev_count - 1)
    end
  end
end
