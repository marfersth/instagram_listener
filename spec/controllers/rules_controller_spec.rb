require 'rails_helper'

describe RulesController, type: :request do

  let(:params) {
    { user_id: 12345678, access_token: 'EAAUiZCczYw5wBAGuok0kUz9IHlLZAxG', campaign_id: 1, flimper_back_rule_id: 1,
      active: true, hashtags: ['hashtag1', 'hashtag2'], users: ['user1', 'user2'], words: ['word1', 'word2'] }
  }

  context '#create' do
    subject do
      lambda do |params|
        post('/rules', params: params, headers: nil)
      end
    end

    it 'with all params' do
      rules_before = Rule.count
      subject.call(rule: params)
      expect(response).to be_success
      expect(Rule.count).to eql(rules_before + 1)
    end

    it 'param active false' do
      rules_before = Rule.count
      subject.call(rule: params.except(:active))
      expect(response).to be_success
      expect(Rule.count).to eql(rules_before)
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
      subject.call(@rule.flimper_back_rule_id, rule: { active: false })
      expect(response).to be_success
      expect(JSON.parse(response.body)['rule']['active']).to be_falsey
    end
  end
end