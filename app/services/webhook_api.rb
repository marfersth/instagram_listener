class WebhookApi
  INSTAGRAM_ENDPOINT = 'https://graph.facebook.com/v4.0'.freeze
  SUBSCRIBED_FIELDS = 'feed'.freeze

  class << self
    # rubocop:disable Style/GuardClause
    def create_subscription(page_id, access_token)
      url = "#{INSTAGRAM_ENDPOINT}/#{page_id}/subscribed_apps"
      response = Faraday.post(url, subscribed_fields: SUBSCRIBED_FIELDS, access_token: access_token)
      unless response.success? && JSON.parse(response.body)['success']
        raise ThirdPartyApiError.new({ url: url, message: response.body }, response.status)
      end
    end

    def delete_subscription(page_id, access_token)
      url = "#{INSTAGRAM_ENDPOINT}/#{page_id}/subscribed_apps"
      response = Faraday.delete(url, access_token: access_token)
      unless response.success? && JSON.parse(response.body)['success']
        raise ThirdPartyApiError.new({ url: url, message: response.body }, response.status)
      end
    end

    def instagram_business_account(page_id, access_token)
      url = "#{INSTAGRAM_ENDPOINT}/#{page_id}?fields=instagram_business_account"
      response = Faraday.get(url, access_token: access_token)
      unless response.success?
        raise ThirdPartyApiError.new({ url: url, message: response.body }, response.status)
      end

      JSON.parse(response.body)['instagram_business_account']['id']
    end
<<<<<<< HEAD
    
    def exchange_short_for_long_lived_token(page_id, page_secret, access_token)
      url = "#{INSTAGRAM_ENDPOINT}/oauth/access_token"
      response = Faraday.get(url, grant_type: 'fb_exchange_token', client_id: page_id, client_secret: page_secret, access_token: access_token)
      unless response.success?
        raise ThirdPartyApiError.new({url: url, message: response.body}, response.status)
      end
      JSON.parse(response.body)['access_token']
    end
=======
    # rubocop:enable Style/GuardClause
>>>>>>> 4a54caa25e1bf4a1e04ae7bb6cfff1955a3d9be6
  end
end
