class SendMention
  def self.execute(activity_subscription, subscriptions, mention)
    subscriptions.each do |subscription|
      mention_and_missing(activity_subscription, subscription, mention)
    end
  end

  def self.mention_and_missing(activity_subscription, subscription, mention)
    response = Subscriptions::Operations::SendCommentAndMention.run!(
      raw_data: mention.raw_data,
      campaign_id: activity_subscription.campaign_id,
      owner_username: mention.owner_username,
      endpoint: subscription.hook_url
    )
    return if response.success?

    MissingMentions::Operations::Create.run!(activity_subscription: activity_subscription,
                                             subscription: subscription, mention: mention)
    response
  end
end
