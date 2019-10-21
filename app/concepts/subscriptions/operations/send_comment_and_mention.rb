# frozen_string_literal: true

module Subscriptions
  module Operations
    class SendCommentAndMention < ActiveInteraction::Base
      string :campaign_id
      string :raw_data
      string :endpoint

      def execute
        Faraday.post(endpoint, campaign_id: campaign_id, raw_data: raw_data)
      end
    end
  end
end
