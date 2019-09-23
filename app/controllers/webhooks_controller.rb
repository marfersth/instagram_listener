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
    event_name = params['entry'].first['changes']['field']
    case event_name
    when "mentions"
      # ir a buscar el texto del comment_id o media_id donde esta la mention, para poder pasarle las reglas
      activity_subscriptions = ActivitySubscription.where(instagram_business_account_id: params['entry'].first['id'])
      activity_subscriptions.each do |activity_subscription|
        #ver si las reglas aplican al texto y mandar a flimper back utlizando las suscription con event comments_and_mentions
        # en el body agregar el campaign_id asi flimper back puede ver a que campaña corresponde
        # Ver tambien que campos es necesario mandar a flimper back (raw_data, campaign_id, texto)
      end
    end
    head :ok
  end
end
