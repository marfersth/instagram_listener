# frozen_string_literal: true

class WebhooksController < ApplicationController
  before_action :filter_params, only: :event
  def validation
    insta_token = ENV.fetch('INSTAGRAM_VERIFY_TOKEN')
    return render json: params['hub.challenge'] if insta_token == params['hub.verify_token']

    head :forbidden
  end

  def event
    case @event_name
    when 'mentions'
      handle_mentions
    end
    head :ok
  end

  private

  def filter_params
    entry = params['entry']
    changes = entry&.first.try(:[], 'changes')
    value = changes&.first.try(:[], 'value')
    @event_name = changes&.first.try(:[], 'field')
    @instagram_business_account_id = entry&.first.try(:[], 'id')
    @comment_id = value.try(:[], 'comment_id')
    @media_id = value.try(:[], 'media_id')
    @raw_data = params.reject! { |p| %w[controller action].include? p }
  end

  def handle_mentions
    activity_subscriptions = ActivitySubscription.where(instagram_business_account_id: @instagram_business_account_id)
    return if activity_subscriptions.empty?

    text = Webhooks::Operations::MentionedText.run!(comment_id: @comment_id, media_id: @media_id,
                                                    instagram_business_account_id: @instagram_business_account_id,
                                                    access_token: activity_subscriptions.last.access_token)
    subscriptions = Subscription.where(event: 'comments_and_mentions')
    related_activity_subscriptions = []
    activity_subscriptions.each do |activity_subscription|
      matchs = text_matching?(activity_subscription, text)
      next unless matchs

      SendMention.execute(activity_subscription, subscriptions)
      related_activity_subscriptions << activity_subscription
    end
    Mention.create!(raw_data: @raw_data.to_json, field_type: @event_name,
                    activity_subscriptions: related_activity_subscriptions)
  end

  def text_matching?(activity_subscription, text)
    words = activity_subscription.words
    hashtags = activity_subscription.hashtags
    Webhooks::Operations::MatchText.run!(text_to_match: text, words: words, hashtags: hashtags)
  end
end
