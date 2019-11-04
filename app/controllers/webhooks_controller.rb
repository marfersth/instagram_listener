# frozen_string_literal: true

class WebhooksController < ApplicationController
  before_action :filter_params, only: :event
  def validation
    insta_token = ENV.fetch('INSTAGRAM_VERIFY_TOKEN')
    return render json: params['hub.challenge'] if insta_token == params['hub.verify_token']

    head :forbidden
  end

  def event
    return if @activity_subscriptions.empty?

    case @event_name
    when 'mentions'
      comment_id = @value.try(:[], 'comment_id')
      media_id = @value.try(:[], 'media_id')
      text = Webhooks::Operations::MentionedText.run!(comment_id: comment_id, media_id: media_id,
                                                      instagram_business_account_id: @instagram_business_account_id,
                                                      access_token: @activity_subscriptions.last.access_token)
      handle_mentions(text)
    end
    head :ok
  end

  private

  def filter_params
    entry = params['entry']
    changes = entry&.first.try(:[], 'changes')
    @value = changes&.first.try(:[], 'value')
    @event_name = changes&.first.try(:[], 'field')
    @instagram_business_account_id = entry&.first.try(:[], 'id')
    @raw_data = params.reject! { |p| %w[controller action].include? p }
    @activity_subscriptions = ActivitySubscription.where(instagram_business_account_id: @instagram_business_account_id)
  end

  def handle_mentions(text)
    subscriptions = Subscription.where(event: 'comments_and_mentions')
    @activity_subscriptions.each do |activity_subscription|
      matchs = text_matching?(activity_subscription, text)
      next unless matchs

      mention = Mention.create!(raw_data: @raw_data.to_json, field_type: @event_name,
                                activity_subscription: activity_subscription)
      SendMention.execute(activity_subscription, subscriptions, mention)
    end
  end

  def text_matching?(activity_subscription, text)
    words = activity_subscription.words
    hashtags = activity_subscription.hashtags
    Webhooks::Operations::MatchText.run!(text_to_match: text, words: words, hashtags: hashtags)
  end
end
