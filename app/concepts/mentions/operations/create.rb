module Mentions
  module Operations
    class Create < ActiveInteraction::Base
      string :field_type
      object :activity_subscription, class: ActivitySubscription
      string :mention_data, default: nil
      string :access_token
      string :text
      string :owner_username

      def execute
        raw_data = creates_raw_data
        Mention.create!(raw_data: raw_data.to_json, field_type: field_type,
                        activity_subscription: activity_subscription, text: text,
                        owner_username: owner_username)
      end

      def creates_raw_data
        media_data.merge(media_id: media_id, comment_id: comment_id, comment_text: text,
                         instagram_business_account_id: instagram_business_account_id)
      end

      def media_data
        media = InstagramGraph::Queries::IgMedia.run!(media_id: media_id, access_token: access_token)
        {
          id: media['id'],
          caption: media['caption'],
          media_type: media['media_type'],
          media_url: media['media_url'],
          children: media['children'],
          permalink: media['permalink'],
          comments_count: media['comments_count']
        }
      end

      def media_value
        @media_value ||= mention_data_json['entry']&.first.try(:[], 'changes')&.first.try(:[], 'value')
      end

      def media_id
        @media_id ||= media_value.try(:[], 'media_id')
      end

      def comment_id
        @comment_id ||= media_value.try(:[], 'comment_id')
      end

      def instagram_business_account_id
        @instagram_business_account_id ||= mention_data_json['entry']&.first.try(:[], 'id')
      end

      def mention_data_json
        @mention_data_json ||= JSON.parse(mention_data)
      end
    end
  end
end
