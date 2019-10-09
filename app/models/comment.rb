class Comment
  include Mongoid::Document
  field :id, type: Integer
  field :text, type: String
  field :post_id, type: String
  field :raw_data, type: String
  field :instagram_post_id, type: String
end
