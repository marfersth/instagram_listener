# frozen_string_literal: true

module InstagramGraph
  module Queries
    class MediaCaption < ActiveInteraction::Base
      string :instagram_business_account_id
      string :media_id
      string :access_token

      def execute
        response = Faraday.get("https://graph.facebook.com/#{instagram_business_account_id}?fields=mentioned_media.media_id(#{media_id}){caption}&access_token=#{access_token}")
        unless response.status == 200
          raise ThirdPartyApiError.new(JSON.parse(response.body)['error']['message'], response.status)
        end

        response = JSON.parse(response.body)
        response['mentioned_media']['caption']
      end
    end
  end
end
