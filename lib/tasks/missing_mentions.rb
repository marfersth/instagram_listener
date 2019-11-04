namespace :missing_mentions do
  desc 'Retry all missing mentions'

  task retry_all: :environment do
    MissingMentions.all.each { |mm| MissingMentions::Operations::RetrySendMention.run!(missing_mention: mm) }
  end
end
