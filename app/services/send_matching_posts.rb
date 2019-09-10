class SendMatchingPosts
  PROCESS_ENDPOINT = ENV['PROCESS_ENDPOINT']

  def self.execute(post_id, raw_data, campaign_id)
    hook_response = Faraday.new.post do |request|
      request.url PROCESS_ENDPOINT
      request.headers['Content-Type'] = 'application/json'
      request.headers['Authorization'] = SendMatchingPosts.izzy_api_jwt_token
      request.body = {
        campaign_id: campaign_id,
        data: raw_data
      }.to_json
    end

    unless hook_response.success?
      raise ThirdPartyApiError.new({ url: PROCESS_ENDPOINT, message: hook_response },
                                   hook_response.status).show_error
    end

    hook_response
  rescue StandardError => e
    Raven.capture_exception(error: e, post_ID: post_id)
    e
  end

  def self.izzy_api_jwt_token
    Jwts::Issuers::ForApiClients.new(name: 'IZZY_API_BACKEND',
                                     authorization_token: ENV.fetch('IZZY_API_CLIENT_TOKEN'))
                                .issue!
  end
end
