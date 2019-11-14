require 'rails_helper'

describe InstagramGraph::Queries::MediaCommentOwner do
  let(:comment_id) { 'comment_id' }
  let(:media_id) { 'media_id' }
  let(:access_token) { 'access_token' }
  let(:ig_username) { 'ig_username' }
  let(:response_body) do
    OpenStruct.new(
      success?: true,
      body: {
        "username": ig_username,
        "id": '17850842479680371'
      }.to_json
    )
  end

  subject do
    lambda do |comment_id = nil|
      InstagramGraph::Queries::MediaCommentOwner.run!(comment_id: comment_id, media_id: media_id,
                                                      access_token: access_token)
    end
  end

  it 'do the request with comment_id' do
    expect(HTTParty).to receive(:get)
      .with("https://graph.facebook.com/#{comment_id}?fields=username&access_token=#{access_token}")
      .and_return(response_body)
    subject.call(comment_id)
  end

  it 'do the request with media_id' do
    expect(HTTParty).to receive(:get)
      .with("https://graph.facebook.com/#{media_id}?fields=username&access_token=#{access_token}")
      .and_return(response_body)
    subject.call
  end

  it 'return the correct username' do
    allow(HTTParty).to receive(:get).and_return(response_body)
    response_username = subject.call
    expect(response_username).to eql(ig_username)
  end
end
