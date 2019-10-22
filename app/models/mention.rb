class Mention
  include ActiveModel::Validations
  include Mongoid::Document

  field :raw_data, type: String
  field :field_type, type: String

  has_and_belongs_to_many :activity_subscriptions

  rails_admin do
    list do
      field :id
      field :raw_data
      field :field_type
    end

    show do
      field :id
      field :raw_data
      field :field_type
    end
  end
end
