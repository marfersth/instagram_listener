class ActivitySubscriptionsController < ApplicationController
  def create
    activity_subscription = ActivitySubscription.create!(activity_subscription_params)
    render json: activity_subscription
  end

  def destroy
    activity_subscription = ActivitySubscription.find(params[:id])
    activity_subscription.destroy
    render json: :ok
  end

  private

  def activity_subscription_params
    params.require(:activity_subscription).permit(:access_token, :page_id, :campaign_id, words: [], hashtags: [])
  end
end