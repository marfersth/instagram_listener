require 'rails_helper'

describe InstagramGraph::Queries::IgMedia do
  let(:access_token) {
    'EAAUiZCczYw5wBAAZAhUfGUDNH44kbKXaWkh7ajlqe6GZBOuhVHVKVjY0emSXry0nlxAfTMrdedEz3HZAmE'\
  'mAVZA7SrOA1k0MhVEZBXs7WoJ9aze6oohLChs82New2tYbFfhyGTjvLNWZAvrLDHHUeE5kqVqdIoUztMCg3MEUq9z6QZDZD'
  }
  let(:media_id) { '18044467927200524' }
  let(:fields) { InstagramGraph::Queries::IgMedia::FIELDS }

  context 'if response is succeed' do
    it 'return appropriate keys' do
      response = VCR.use_cassette('media_data/succeed') do
        InstagramGraph::Queries::IgMedia.run!(media_id: media_id, access_token: access_token)
      end
      expect(response.keys).to eql(%w[id media_type comments comments_count permalink media_url like_count caption])
    end
  end

  context 'if response fails' do
    it 'trigger an exception' do
      VCR.use_cassette('media_data/error') do
        expect {
          InstagramGraph::Queries::IgMedia.run!(media_id: media_id, access_token: '')
        } .to raise_error(ThirdPartyApiError)
      end
    end
  end
end
