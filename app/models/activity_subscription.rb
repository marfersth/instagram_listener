class ActivitySubscription
  include ActiveModel::Validations
  include Mongoid::Document

  field :access_token, type: String
  field :page_id, type: String
  field :campaign_id, type: String
  field :instagram_business_account_id, type: String
  field :words, type: Array, default: []
  field :hashtags, type: Array, default: []

  validates :access_token, presence: true

  before_create :add_facebook_subscription, :exchange_long_lived_token
  before_destroy :remove_facebook_subscription
  before_save :remove_blank_elements_array

  rails_admin do
    list do
      field :access_token
      field :page_id
      field :campaign_id
      field :instagram_business_account_id
      field :words
      field :hashtags
    end
  end

  private

  def add_facebook_subscription
    if (activity_subscriptions = ActivitySubscription.where(page_id: page_id)).empty?
      WebhookApi.create_subscription(page_id, access_token)
      instagram_business_account_id = WebhookApi.instagram_business_account(page_id, access_token)
    else
      instagram_business_account_id = activity_subscriptions.first.instagram_business_account_id
    end
    assign_attributes(instagram_business_account_id: instagram_business_account_id)
  end

  def remove_facebook_subscription
    return if ActivitySubscription.where(page_id: page_id).count > 1

    WebhookApi.delete_subscription(page_id, access_token)
  end

  def remove_blank_elements_array
    assign_attributes(words: words.try(:reject, &:empty?),
                      hashtags: hashtags.try(:reject, &:empty?))
  end

  def exchange_long_lived_token
    flimper_app_id = ENV.fetch('FLIMPER_APP_ID')
    flimper_app_secret = ENV.fetch('FLIMPER_APP_SECRET')
    long_life_token = WebhookApi.exchange_short_for_long_lived_token(flimper_app_id, flimper_app_secret, access_token)
    @access_token = long_life_token
  end
end
