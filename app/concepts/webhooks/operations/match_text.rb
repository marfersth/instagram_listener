# frozen_string_literal: true

module Webhooks
  module Operations
    class MatchText < ActiveInteraction::Base
      string :text_to_match
      array :words
      array :hashtags

      def execute
        downcased_text_to_match = text_to_match&.downcase
        word_matches = words.map { |word| downcased_text_to_match.include? word.downcase }
        hashtag_matches = hashtags.map { |hashtag| downcased_text_to_match.include?('#' + hashtag.downcase) }
        !word_matches.include?(false) && !hashtag_matches.include?(false)
      end
    end
  end
end
