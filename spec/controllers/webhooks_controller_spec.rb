require 'rails_helper'

RSpec.describe WebhooksController, type: :controller do
  let(:body_media) {
    { object: 'instagram',
      entry: [
        { id: '123',
          time: 1_568_396_461,
          changes: [
            { value: { media_id: '18062598958141247' },
              field: 'mentions' }
          ] }
      ],
      webhook: { object: 'instagram', entry: [
        { id: '123',
          time: 1_568_396_461,
          changes: [
            { value: { media_id: '18062598958141247' },
              field: 'mentions' }
          ] }
      ] } }
  }

  let(:body_comment) {
    { object: 'instagram',
      entry: [
        { id: '123',
          time: 1_568_396_461,
          changes: [
            { value: { media_id: '18062598958141247',
                       comment_id: '17876685787436635' },
              field: 'mentions' }
          ] }
      ],
      webhook: { object: 'instagram', entry: [
        { id: '123',
          time: 1_568_396_461,
          changes: [
            { value: { media_id: '18062598958141247',
                       comment_id: '17876685787436635' },
              field: 'mentions' }
          ] }
      ] } }
  }

  it 'asks for caption when the event is a media mention' do
    create :activity_subscription

    expect(InstagramGraph::Queries::MediaCaption).to receive(:run!).with(any_args).and_return('Texto de prueba')

    post :event, params: body_media

    expect(response).to be_success
  end

  it 'asks for text when the event is a comment mention' do
    create :activity_subscription

    expect(InstagramGraph::Queries::CommentText).to receive(:run!).with(any_args).and_return('Texto de prueba')

    post :event, params: body_comment

    expect(response).to be_success
  end
end
