class WebhooksController < ApplicationController
  def validation
    insta_token = ENV.fetch('INSTAGRAM_VERIFY_TOKEN')
    return render json: params['hub.challenge'] if insta_token == params['hub.verify_token']

    head :forbidden
  end

  # rubocop:disable Style/AsciiComments
  # rubocop:disable Metrics/LineLength
  def event
    event_name = params['entry'].first['changes'].first['field']
    case event_name
    when 'mentions'
      comment_id = params['entry'].first['changes'].first['value']['comment_id']
      if comment_id
        'hay comment id'
      else
        'no hay comment id'
      end
      text = 'Algun texto de prueba #yolo' # hacer un llamado a la api que nos entregue el texto usando el comment o media id
      # ir a buscar el texto del comment_id o media_id donde esta la mention, para poder pasarle las reglas
      activity_subscriptions = ActivitySubscription.where(instagram_business_account_id: params['entry'].first['id'])
      activity_subscriptions.each do |activity_subscription|
        # ver si las reglas aplican al texto y mandar a flimper back utlizando las suscription con event comments_and_mentions
        next unless Webhooks::Operations::MatchText.run!(text, activity_subscription.words,
                                                         activity_subscription.hashtags)
        # en el body agregar el campaign_id asi flimper back puede ver a que campaña corresponde
        # Ver tambien que campos es necesario mandar a flimper back (raw_data, campaign_id, texto)
      end
    end
    head :ok
  end
  # rubocop:enable Style/AsciiComments
  # rubocop:enable Metrics/LineLength
end
