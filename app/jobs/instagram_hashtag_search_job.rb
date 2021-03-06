require 'sidekiq-scheduler'

class InstagramHashtagSearchJob
  include Sidekiq::Worker
  sidekiq_options queue: :instagram_hashtag_search, unique: :until_executed, retry: false

  def perform(rule_id)
    Rails.logger.info 'Started Job: InstagramHashtagSearch'
    rule = Rule.find(rule_id)
    matching_posts = HashtagSearch.matching_posts(rule)
    filtered_posts = rule.filer_posts(matching_posts)
    filtered_posts.each do |post|
      SendMatchingPosts.execute(post.id, post.raw_data, post.rule.campaign_id)
    rescue StandardError
      post.update!(missing: true)
    end
    Rails.logger.info 'Ended Job: InstagramHashtagSearch'
  end
end
