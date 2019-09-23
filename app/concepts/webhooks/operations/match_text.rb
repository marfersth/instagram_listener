# frozen_string_literal: true

module Webhooks
    module Operations
      class MatchText < ActiveInteraction::Base
        string :text_to_match
        array :words
        array :hashtags
  
        def execute
            word_matches = words.map { |word| text_to_match.include? word }
            hashtag_matches = hashtags.map {|hashtag| text_to_match.include?('#' + hashtag)}
            !word_matches.include?(false) && !hashtag_matches.include?(false)
        end
      end
    end
  end
  