require 'rails_helper'

describe HashtagSearch do
  let(:rule) do
    create(:rule,
           user_id: 17841412154572203,
           access_token: 'EAAUiZCczYw5wBAGuok0kUz9IHlLZAxGonmNQzBPtzwtgft9LfJ7fGIYXOZBEBrLZAZBAyZBerjSqAZAAVwZAm64OpU'\
           '9bJMm8PXnsfzWutGDmZAdhSGMMixCsFdZAnZAcKM1Yot7ZAVq0pZBZCW0wCYIfwAar1uWHP1ZAwUDAhbTcPeRhJpVRu5gvpL3YLZAs',
           hashtags: ['coke'])
  end

  it '#hashtag_search', type: :request do
    hastag_id = VCR.use_cassette('hashtag_search') do
      HashtagSearch.hashtag_search(rule)
    end
    expect(hastag_id[:data][:id]).not_to be_nil # {"data"=>[{"id"=>"17841593698074073"}]}
  end

  it '#hashtag_posts' do
    posts = VCR.use_cassette('hashtag_posts') do
      HashtagSearch.hashtag_posts('17841593698074073',rule)
    end
    expect(posts.first.keys).to eql([:id, :caption]) #[{id: '', caption: ''}]
  end

  it '#matching_posts' do
    expect(HashtagSearch).to receive(:hashtag_search).with(rule).and_return({data: [{id: '17841593698074073'}]})
    expect(HashtagSearch).to receive(:hashtag_posts).with('17841593698074073', rule).and_return([{id: '123', caption: 'instagram caption' }])
    posts = HashtagSearch.matching_posts(rule.id)
    expect(posts.first.keys).to eql([:id, :caption]) #[{id: '', caption: ''}]
  end
end