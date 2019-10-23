# frozen_string_literal: true

module Subscriptions
  module Operations
    class SendCommentAndMention < ActiveInteraction::Base
      string :campaign_id
      string :raw_data
      string :endpoint

      def execute
        HTTParty.post(endpoint,
                      body: {
                        campaign_id: campaign_id,
                        raw_data: raw_data
                      }.to_json,
                      headers: { 'Content-Type' => 'application/json' })
      end
    end
  end
end
