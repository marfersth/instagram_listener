# frozen_string_literal: true

module InstagramGraph
  module Queries
    class CommentText < ActiveInteraction::Base
      string :instagram_business_account_id
      string :comment_id
      string :access_token

      def execute
        # rubocop:disable Metrics/LineLength
        response = Faraday.get("https://graph.facebook.com/#{instagram_business_account_id}?fields=mentioned_comment.comment_id(#{comment_id})&access_token=#{access_token}")
        # rubocop:enable Metrics/LineLength
        unless response.status == 200
          raise ThirdPartyApiError.new(JSON.parse(response.body)['error']['message'], response.status)
        end

        response = JSON.parse(response.body)
        response['mentioned_comment']['text']
      end
    end
  end
end
