class WebhookApi
  INSTAGRAM_ENDPOINT = 'https://graph.facebook.com/v4.0'.freeze
  SUBSCRIBED_FIELDS = 'feed, mention, name, picture, category, description, conversations, founded, company_overview, '\
'mission, products, general_info, leadgen_fat, location, hours, parking, public_transit, page_about_story, '\
'commerce_order, phone, email, website, ratings, attire, payment_options, culinary_team, general_manager, '\
'price_range, awards, hometown, current_location, bio, affiliation, birthday, personal_info, personal_interests, '\
'publisher_subscriptions, members, checkins, page_upcoming_change, page_change_proposal, merchant_review, '\
'product_review, videos, live_videos, video_text_question_responses, registration'

  class << self
    def create_subscription(page_id, access_token)
      url = "#{INSTAGRAM_ENDPOINT}/#{page_id}/subscribed_apps"
      response = Faraday.post(url, subscribed_fields: SUBSCRIBED_FIELDS, access_token: access_token)
      unless response.success? && JSON.parse(response.body)['success']
        raise ThirdPartyApiError.new({url: url, message: response.body}, response.status)
      end
    end

    def delete_subscription(page_id, access_token)
      url = "#{INSTAGRAM_ENDPOINT}/#{page_id}/subscribed_apps"
      response = Faraday.delete(url, access_token: access_token)
      unless response.success? && JSON.parse(response.body)['success']
        raise ThirdPartyApiError.new({url: url, message: response.body}, response.status)
      end
    end

    def instagram_business_account(page_id, access_token)
      url = "#{INSTAGRAM_ENDPOINT}/#{page_id}?fields=instagram_business_account"
      response = Faraday.get(url, access_token: access_token)
      unless response.success?
        raise ThirdPartyApiError.new({url: url, message: response.body}, response.status)
      end
      JSON.parse(response.body)['instagram_business_account']['id']
    end
  end
end