class SendMention
  def self.execute(activity_subscription, subscriptions, raw_data)
    subscriptions.each do |subscription|
      Subscriptions::Operations::SendCommentAndMention.run!(
        raw_data: raw_data.to_json,
        campaign_id: activity_subscription.campaign_id,
        endpoint: subscription.hook_url
      )
    end
  end
end
