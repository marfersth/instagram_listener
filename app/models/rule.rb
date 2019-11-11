class Rule
  include ActiveModel::Validations
  include Mongoid::Document

  field :user_id, type: Integer
  field :access_token, type: String
  field :campaign_id, type: Integer
  field :active, type: Boolean, default: true
  field :hashtags, type: Array
  field :users, type: Array
  field :words, type: Array
  field :last_post_id, type: Integer
  field :flimper_back_rule_id, type: Integer

  has_many :posts, dependent: :destroy

  validates :user_id, :access_token, :campaign_id, :flimper_back_rule_id, presence: true
  validates :flimper_back_rule_id, uniqueness: true

  rails_admin do
    list do
      field :user_id
      field :access_token
      field :campaign_id
      field :active
      field :hashtags
      field :users
      field :words
      field :last_post_id
    end
  end

  def filer_posts(incoming_posts)
    filtered_posts = []
    reduced_posts = incoming_posts
                    .map { |p| { id: p['id'], caption: p['caption'] }.with_indifferent_access }
    reduced_posts.each do |reduced_post|
      next unless posts.where(instagram_id: reduced_post['id']).count.zero?

      raw_data = incoming_posts.select { |p| p['id'] == reduced_post['id'] }.first
      next if raw_data['caption'].blank? || !post_valid?(raw_data['caption'])

      filtered_posts << posts.create!(rule_id: id, instagram_id: raw_data['id'],
                                      caption: raw_data['caption'], raw_data: raw_data)
      update!(last_post_id: filtered_posts.last['id'])
    end
    filtered_posts
  end

  private

  def post_valid?(post_caption)
    hashtags_valid?(post_caption) && words_valid?(post_caption)
  end

  def words_valid?(post_caption)
    words_post = post_caption.downcase.scan(regex_specific(''))
    validate_type_rule?(words_post, (words + users).reject(&:blank?))
  end

  def hashtags_valid?(post_caption)
    hashtags_post = extract_specifics(post_caption, '#')
    validate_type_rule?(hashtags_post, hashtags)
  end

  def extract_specifics(string, character)
    list_specific = string.downcase.scan(regex_specific(character)).flatten
    remove_symbol(list_specific, character)
  end

  def remove_symbol(list_specific, character)
    list_specific.map { |specific| specific.split(character)[1] }.compact
  end

  def regex_specific(character)
    /#{character}[a-zA-Z0-9ñÑáéíóúÁÉÍÓÚ._-]+/
  end

  def validate_type_rule?(rule_post_array, rule_array)
    return true if rule_array.size.zero?

    rule_valid = []
    rule_array = rule_array.map(&:downcase)
    rule_array.each do |item|
      rule_valid << item if rule_post_array.include?(item)
    end
    rule_valid == rule_array
  end
end
