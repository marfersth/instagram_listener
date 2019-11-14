# frozen_string_literal: true

module Subscriptions
  module Operations
    class SendCommentAndMention < ActiveInteraction::Base
      string :campaign_id
      string :raw_data
      string :endpoint
      string :owner_username

      def execute
        HTTParty.post(endpoint,
                      body: {
                        campaign_id: campaign_id,
                        owner_username: owner_username,
                        raw_data: raw_data
                      }.to_json,
                      headers: { 'Content-Type' => 'application/json' })
      end
    end
  end
end
