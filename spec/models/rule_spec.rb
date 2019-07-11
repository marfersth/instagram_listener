require 'rails_helper'

describe Rule do
  let(:posts)do
    file = File.read('spec/files/instagram_posts.json')
    JSON.parse(file)
  end
  let(:rule){ create :rule, hashtags: ['coke','cocacola'], words: ['city'], users: ['user1']}

  it '#filer_posts' do
    filtered_posts = rule.filer_posts(posts)
    expect(filtered_posts.map(&:instagram_id)).to match_array([18002569231226927, 17845022812502879])
  end

  context '#words_valid?' do
    it 'valid post' do
      post = posts.select{|p| p['id'] == '18002569231226927'}.first
      response = rule.send(:words_valid?, post['caption'])
      expect(response).to be_truthy
    end
    it 'invalid post' do
      response = rule.send(:words_valid?, posts.first['caption'])
      expect(response).to be_falsey
    end
  end

  context '#users_valid?' do
    it 'valid post' do
      post = posts.select{|p| p['id'] == '18002569231226927'}.first
      response = rule.send(:users_valid?, post['caption'])
      expect(response).to be_truthy
    end
    it 'invalid post' do
      response = rule.send(:users_valid?, posts.first['caption'])
      expect(response).to be_falsey
    end
  end

  context '#hashtags_valid?' do
    it 'valid post' do
      response = rule.send(:hashtags_valid?, posts.first['caption'])
      expect(response).to be_truthy
    end
    it 'invalid post' do
      post = posts.select{|p| p['id'] == '17846833096501227'}.first
      response = rule.send(:hashtags_valid?, post['caption'])
      expect(response).to be_falsey
    end
  end
end