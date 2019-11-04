class MissingMention
  include ActiveModel::Validations
  include Mongoid::Document

  belongs_to :activity_subscription
  belongs_to :mention
  belongs_to :subscription

  rails_admin do
    list do
      field :activity_subscription
      field :mention
      field :subscription
    end
  end
end
