# frozen_string_literal: true

class WebhooksController < ApplicationController
  def validation
    insta_token = ENV.fetch('INSTAGRAM_VERIFY_TOKEN')
    return render json: params['hub.challenge'] if insta_token == params['hub.verify_token']

    head :forbidden
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def event
    event_name = params['entry'].first['changes'].first['field']
    case event_name
    when 'mentions'

      instagram_business_account_id = params['entry'].first['id']
      activity_subscriptions = ActivitySubscription.where(instagram_business_account_id: instagram_business_account_id)

      unless activity_subscriptions.empty?
        comment_id = params['entry'].first['changes'].first['value']['comment_id']
        media_id = params['entry'].first['changes'].first['value']['media_id']
        access_token = activity_subscriptions.first.access_token

        text = if comment_id.nil?
                 InstagramGraph::Queries::MediaCaption.run!(
                   instagram_business_account_id: instagram_business_account_id,
                   media_id: media_id, access_token: access_token
                 )
               else
                 InstagramGraph::Queries::CommentText.run!(instagram_business_account_id: instagram_business_account_id,
                                                           comment_id: comment_id, access_token: access_token)
               end

        subscriptions = Subscription.where(event: 'comments_and_mentions')

        related_activity_subscriptions = []

        activity_subscriptions.each do |activity_subscription|
          words = activity_subscription.words
          hashtags = activity_subscription.words
          next unless Webhooks::Operations::MatchText.run!(text_to_match: text, words: words, hashtags: hashtags)

          subscriptions.each do |subscription|
            Subscriptions::Operations::SendCommentAndMention.run!(
              text: text,
              campaign_id: activity_subscription.campaign_id,
              endpoint: subscription.hook_url
            )
          end
          related_activity_subscriptions << activity_subscription
        end
      end

      Mention.create(raw_data: request.raw_post, field_type: 'mentions',
                     activity_subscriptions: related_activity_subscriptions)

    end
    head :ok
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
