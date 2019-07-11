require 'rails_helper'

describe RulesController, type: :request do

  let(:params) {
    { user_id: 12345678, access_token: 'EAAUiZCczYw5wBAGuok0kUz9IHlLZAxG', campaign_id: 1,
      hashtags: ['hashtag1', 'hashtag2'], users: ['user1', 'user2'], words: ['word1', 'word2'] }
  }

  context '#create' do
    subject do
      lambda do |params|
        post('/rules', params: params, headers: nil)
      end
    end

    it 'with all params' do
      subject.call(rule: params)
      expect(response).to be_success
    end
  end

  context '#update' do
    subject do
      lambda do |id, params|
        put("/rules/#{id}", params: params, headers: nil)
      end
    end

    before do
      @rule = create(:rule, hashtags: ['hashtag'], users: ['user'], words: ['word'])
    end

    it 'update ' do
      subject.call(@rule.id, rule: { active: false })
      expect(response).to be_success
      expect(JSON.parse(response.body)['rule']['active']).to be_falsey
    end
  end
end