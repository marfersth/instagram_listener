class Mentions
  include ActiveModel::Validations
  include Mongoid::Document

  field :raw_data, type: String
  field :field_type, type: String
  field :activity_subscription_id, type: Integer

  belongs_to :activity_subscription

  rails_admin do
    list do
      field :raw_data
      field :field_type
      field :activity_subscription_id
    end
  end
end
