require 'rails_helper'

describe HashtagSearch do
  let(:access_token) do
    'EAAUiZCczYw5wBAGuok0kUz9IHlLZAxGonmNQzBPtzwtgft9LfJ7fGIYXOZBEBrLZAZBAyZBerjSqAZAAVwZAm64OpU'\
    '9bJMm8PXnsfzWutGDmZAdhSGMMixCsFdZAnZAcKM1Yot7ZAVq0pZBZCW0wCYIfwAar1uWHP1ZAwUDAhbTcPeRhJpVRu'\
    '5gvpL3YLZAs'
  end

  let(:post_id) { '17841593698074073' }

  let(:rule) do
    create(:rule,
           user_id: 17_841_412_154_572_203,
           access_token: access_token,
           hashtags: ['coke'])
  end

  it '#hashtag_search', type: :request do
    hastag_id = VCR.use_cassette('hashtag_search') do
      HashtagSearch.hashtag_search(rule)
    end
    expect(hastag_id[:data].first[:id]).not_to be_nil # {"data"=>[{"id"=>"17841593698074073"}]}
  end

  it '#hashtag_posts' do
    posts = VCR.use_cassette('hashtag_posts') do
      HashtagSearch.hashtag_posts(post_id, rule)
    end
    expect(posts.first.keys).to eql(%w[id caption media_type media_url permalink])
  end

  it '#matching_posts' do
    expect(HashtagSearch).to receive(:hashtag_search)
      .with(rule)
      .and_return(data: [{ id: '17841593698074073' }])
    expect(HashtagSearch).to receive(:hashtag_posts)
      .with(post_id, rule)
      .and_return([{ id: '123', caption: 'instagram caption' }])
    posts = HashtagSearch.matching_posts(rule.id)
    expect(posts.first.keys).to eql(%i[id caption]) # [{id: '', caption: ''}]
  end
end
