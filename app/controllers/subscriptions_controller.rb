class SubscriptionsController < ApplicationController

  def create
    subscription = Subscription.create!(event: subscription_params[:event_type], hook_url: subscription_params[:hook_url])
    render :json => subscription
  end

  private

  def subscription_params
    params.permit(:event_type, :hook_url)
  end
end