class WebhookApi
  INSTAGRAM_ENDPOINT = 'https://graph.facebook.com/v4.0'.freeze
  SUBSCRIBED_FIELDS = 'feed'.freeze

  class << self
    def create_subscription(page_id, access_token)
      url = "#{INSTAGRAM_ENDPOINT}/#{page_id}/subscribed_apps"
      response = HTTParty.post(url,
                               body: {
                                 subscribed_fields: SUBSCRIBED_FIELDS,
                                 access_token: access_token
                               })
      return unless response.success?

      raise ThirdPartyApiError.new({ url: url, message: response.body }, response.code)
    end

    def delete_subscription(page_id, access_token)
      url = "#{INSTAGRAM_ENDPOINT}/#{page_id}/subscribed_apps"
      HTTParty.delete(url, body: { access_token: access_token })
    end

    def instagram_business_account(page_id, access_token)
      url = "#{INSTAGRAM_ENDPOINT}/#{page_id}?fields=instagram_business_account"
      response = HTTParty.get(url, body: { access_token: access_token })
      raise ThirdPartyApiError.new({ url: url, message: response.body }, response.code) unless response.success?

      JSON.parse(response.body)['instagram_business_account']['id']
    end

    def exchange_short_for_long_lived_token(page_id, page_secret, access_token)
      url = "#{INSTAGRAM_ENDPOINT}/oauth/access_token"
      response = HTTParty.get(url,
                              body: {
                                grant_type: 'fb_exchange_token',
                                client_id: page_id,
                                client_secret: page_secret,
                                access_token: access_token
                              })
      raise ThirdPartyApiError.new({ url: url, message: response.body }, response.code) unless response.success?

      JSON.parse(response.body)['access_token']
    end
  end
end
