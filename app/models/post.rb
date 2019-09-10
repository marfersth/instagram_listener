class Post
  include ActiveModel::Validations
  include Mongoid::Document

  field :instagram_id, type: Integer
  field :caption, type: String
  field :raw_data, type: String
  field :missing, type: Boolean, default: false
  field :rule_id, type: Integer

  belongs_to :rule

  validates :instagram_id, :caption, :raw_data, presence: true

  rails_admin do
    list do
      field :instagram_id
      field :caption
      field :raw_data
      field :missing
    end
  end

  rails_admin do
    list do
      field :instagram_id
      field :caption
      field :raw_data
      field :missing
    end
  end
end
