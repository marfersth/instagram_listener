module Webhooks
  module Operations
    class MentionedText < ActiveInteraction::Base
      string :instagram_business_account_id
      string :media_id
      string :access_token
      string :comment_id, default: nil

      def execute
        if comment_id.blank?
          InstagramGraph::Queries::MediaCaption.run!(
            instagram_business_account_id: instagram_business_account_id,
            media_id: media_id, access_token: access_token
          )
        else
          InstagramGraph::Queries::CommentText.run!(instagram_business_account_id: instagram_business_account_id,
                                                    comment_id: comment_id, access_token: access_token)
        end
      end
    end
  end
end
