require 'rails_helper'

describe ActivitySubscription do

  context 'required field' do
    it 'access_token' do
      expect{ create :activity_subscription, access_token: nil }.to raise_error
    end
  end

  context 'save callbacks' do
    context 'add_facebook_subscription && instagram_business_account' do
      it 'no other subscription for same page' do
        as = build :activity_subscription
        expect(WebhookApi).to receive(:create_subscription).with(as.page_id, as.access_token)
        expect(WebhookApi).to receive(:instagram_business_account).with(as.page_id, as.access_token).and_return('1')
        as.save
      end
      it 'another subscription for the same page already created' do
        stub_create_webhook_subscription
        create :activity_subscription
        as = build :activity_subscription
        expect(WebhookApi).to_not receive(:create_subscription)
        expect(WebhookApi).to_not receive(:instagram_business_account)
        as.save
      end
    end

    context 'remove_facebook_subscription' do
      before do
        stub_create_webhook_subscription
        @as = create :activity_subscription
      end
      it 'only activity_subscription' do
        expect(WebhookApi).to receive(:delete_subscription).with(@as.page_id, @as.access_token)
        @as.destroy
      end
      it 'multiple activity_subscription' do
        create :activity_subscription
        expect(WebhookApi).to_not receive(:delete_subscription)
        @as.destroy
      end
    end
  end
end