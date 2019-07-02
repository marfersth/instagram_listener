class SendMatchingPosts
  PROCESS_ENDPOINT = ENV['PROCESS_ENDPOINT']

  def self.execute(raw_data, campaign_id)
    response = Faraday.new.post do |request|
      request.url PROCESS_ENDPOINT
      request.headers['Content-Type'] = 'application/json'
      request.body = {
        campaign_id: campaign_id,
        data: raw_data
      }
    end
    raise ThirdPartyApiError.new({url: PROCESS_ENDPOINT, message: response.body}, response.status) if response.status != 200
  end
end