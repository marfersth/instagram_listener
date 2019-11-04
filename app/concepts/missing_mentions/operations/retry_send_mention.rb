# frozen_string_literal: true

module MissingMentions
  module Operations
    class RetrySendMention < ActiveInteraction::Base
      object :missing_mention, class: MissingMention

      def execute
        response = SendMention.mention_and_missing(activity_subscription, subscription, mention)
        missing_mention.destroy if response.success?
      end

      private

      def mention
        missing_mention.mention
      end

      def subscription
        missing_mention.subscription
      end

      def activity_subscription
        missing_mention.activity_subscription
      end
    end
  end
end
