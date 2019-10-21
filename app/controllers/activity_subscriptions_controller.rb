class ActivitySubscriptionsController < ApplicationController
  def create
    activity_subscription = create_or_update_activity_subscription
    render json: activity_subscription
  end

  def destroy
    ActivitySubscription.where(campaign_id: params[:campaign_id]).destroy_all
    render json: :ok
  end

  private

  def activity_subscription_params
    params.require(:activity_subscription).permit(:access_token, :page_id, :campaign_id,
                                                  :rule_id, words: [], hashtags: [])
  end

  def create_or_update_activity_subscription
    activity_subscription = ActivitySubscription.find_or_initialize_by(rule_id: activity_subscription_params[:rule_id])
    activity_subscription.update!(activity_subscription_params)
    activity_subscription
  end
end
