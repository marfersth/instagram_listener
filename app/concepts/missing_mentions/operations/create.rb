module MissingMentions
  module Operations
    class Create < ActiveInteraction::Base
      object :activity_subscription, class: ActivitySubscription
      object :mention, class: Mention
      object :subscription, class: Subscription

      def execute
        MissingMention.find_or_create_by(activity_subscription: activity_subscription, mention: mention,
                                         subscription: subscription)
      end
    end
  end
end
