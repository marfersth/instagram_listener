class WebhooksController < ApplicationController
  def validation

    insta_token = ENV.fetch("INSTAGRAM_VERIFY_TOKEN")
    if insta_token == params["hub.verify_token"]
      return render json: params["hub.challenge"] 
    else
      head :forbidden
    end
  end

  def event
    puts params['webhook']
  end
end
