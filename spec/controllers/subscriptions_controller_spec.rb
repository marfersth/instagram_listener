require 'rails_helper'

describe SubscriptionsController, type: :request do

  let(:params) {
    { event_type: 'comments_and_mentions', hook_url: 'http://some_callback_url.com' }
  }

  it '.create' do
    pre_subscription = Subscription.count
    post('/subscriptions', params: params, headers: nil)
    expect(response).to be_success
    expect(Subscription.count).to eql(pre_subscription + 1)
  end
end