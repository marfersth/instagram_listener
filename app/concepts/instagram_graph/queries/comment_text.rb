# frozen_string_literal: true

module InstagramGraph
  module Queries
    class CommentText < ActiveInteraction::Base
      string :instagram_business_account_id
      string :comment_id
      string :access_token
      string :fields

      def execute
        response = Faraday.get("https://graph.facebook.com/#{instagram_business_account_id}?"\
"fields=mentioned_comment.comment_id(#{comment_id}){username,text,media{#{fields}}}&access_token=#{access_token}")
        unless response.status == 200
          raise ThirdPartyApiError.new(JSON.parse(response.body)['error']['message'], response.status)
        end

        response = JSON.parse(response.body)
        { text: response['mentioned_comment']['text'], username: response['mentioned_comment']['username'],
          media: response['mentioned_comment']['media'] }
      end
    end
  end
end
