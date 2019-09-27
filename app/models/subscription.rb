# frozen_string_literal: true

class Subscription
  include ActiveModel::Validations
  include Mongoid::Document

  field :event, type: String, default: 'comments_and_mentions'
  field :hook_url, type: String
  field :active, type: Boolean, default: true

  validates :hook_url, uniqueness: { scope: :event }, presence: true
  validates_with HookUrlValidator

  scope :active_ones, -> { where(active: true) }
  scope :comments_and_mentions_subscriptions, -> { where(event: 'tweets') }

  rails_admin do
    list do
      field :event
      field :hook_url
      field :active
    end

    show do
      field :event
      field :hook_url
      field :active
    end

    edit do
      field :event
      field :hook_url
      field :active
    end
  end
end
