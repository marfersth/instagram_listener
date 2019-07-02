class Rule
  include ActiveModel::Validations
  include Mongoid::Document

  field :user_id, type: Integer
  field :access_token, type: String
  field :campaign_id, type: Integer
  field :post_id, type: Integer
  field :active, type: Boolean, default: true
  field :hashtags, type: Array
  field :users, type: Array
  field :words, type: Array
  field :last_post_id, type: Integer

  has_many :posts
  has_many :missing_posts

  validates :user_id, :access_token, :campaign_id, :active, presence: true

  def filer_posts(posts)
    filtered_posts = []
    reduced_posts = posts['data'].map{|p| {id: p['id'], caption: p['caption']}}
    reduced_posts.each do |post|
      break if post['id'] == last_post_id # post already
      next unless posts.where(instagram_id: post['id']).count.zero?
      raw_data = posts['data'].select{|p| p['id'] == post['id']}
      filtered_posts << Post.create!(rule_id: id, instagram_id: post['id'], caption: post['caption'], raw_data: raw_data)
      update!(last_post_id: p['id'])
    end
    filtered_posts
  end

  def not_processed
    # cuando la el job en sidekiq fallo muchas veces guardar el post como 'missing'
  end


  def self.filter_post(posts, rule)
    posts['data'].each do |post|
      next unless post.key?('caption')
      if new_interaction?(post)
        interaction = FacetagramInteraction.new(campaign: campaign, stream: post)
        interaction.save if post_valid?(post, rule)
      end
    end

    return unless next_iteration?(posts)
    posts = resource_media(posts['paging']['next'])
    filter_post(posts, rule)
  end
end