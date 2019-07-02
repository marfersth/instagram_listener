class MissingPost
  include ActiveModel::Validations
  include Mongoid::Document

  field :instagram_id, type: Integer
  field :caption, type: String
  field :raw_data, type: String

  belongs_to :rule

  validates :instagram_id, :caption, :raw_data, presence: true

  rails_admin do
    list do
      field :caption
      field :raw_data
    end
  end
end