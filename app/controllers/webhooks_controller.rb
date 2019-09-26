# frozen_string_literal: true

class WebhooksController < ApplicationController
  def validation
    insta_token = ENV.fetch('INSTAGRAM_VERIFY_TOKEN')
    if insta_token == params['hub.verify_token']
      return render json: params['hub.challenge']
    else
      head :forbidden
    end
  end

  def event
    event_name = params['entry'].first['changes'].first['field']
    case event_name
    when 'mentions'
      activity_subscriptions = ActivitySubscription.where(instagram_business_account_id: instagram_business_account_id)
      
      comment_id = params['entry'].first['changes'].first['value']['comment_id']
      media_id = params['entry'].first['changes'].first['value']['media_id']
      instagram_business_account_id = params['entry'].first['id']
      access_token = activity_subscriptions.first.access_token

      if comment_id.nil?
        text = InstagramGraph::Queries::MediaCaption.run!(instagram_business_account_id: instagram_business_account_id, media_id: media_id, access_token: access_token)
      else
        text = InstagramGraph::Queries::CommentText.run!(instagram_business_account_id: instagram_business_account_id, comment_id: comment_id, access_token: access_token)
      end

      activity_subscriptions.each do |activity_subscription|
        # ver si las reglas aplican al texto y mandar a flimper back utlizando las suscription con event comments_and_mentions
        if Webhooks::Operations::MatchText.run!(text, activity_subscription.words, activity_subscription.hashtags)
          # en el body agregar el campaign_id asi flimper back puede ver a que campaña corresponde
          # Ver tambien que campos es necesario mandar a flimper back (raw_data, campaign_id, texto)
        end
      end
    end
    head :ok
  end
end
