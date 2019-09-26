require 'rails_helper'

RSpec.describe WebhooksController, type: :controller do
  let(:body) {
    { object: 'instagram',
      entry: [
        { id: '17841408163154441',
          time: 1_568_396_461,
          changes: [
            { value: { media_id: '18062598958141247',
                       comment_id: '17876685787436635' },
              field: 'mentions' }
          ] }
      ],
      webhook: { object: 'instagram', entry: [
        { id: '17841408163154441',
          time: 1_568_396_461,
          changes: [
            { value: { media_id: '18062598958141247',
                       comment_id: '17876685787436635' },
              field: 'mentions' }
          ] }
      ] } }
  }

  it 'event' do
    post :event, params: body
    expect(response).to be_success
  end
end
