# frozen_string_literal: true

module Subscriptios
  module Operations
    class SendCommentAndMention < ActiveInteraction::Base
      string :text
      string :campaign_id
      string :raw_data
      string :endpoint

      def execute
        Faraday.post(endpoint, text: text, campaign_id: campaign_id, raw_data: raw_data)
      end
    end
  end
end
