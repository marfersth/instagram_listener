class Mention
  include ActiveModel::Validations
  include Mongoid::Document

  field :raw_data, type: String
  field :field_type, type: String
  field :text, type: String

  belongs_to :activity_subscription

  rails_admin do
    list do
      field :id
      field :raw_data
      field :text
      field :field_type
    end

    show do
      field :id
      field :raw_data
      field :text
      field :field_type
      field :activity_subscription
    end
  end
end
