FactoryBot.define do
  factory :subscription do
    event { 'comments_and_mentions' }
    hook_url { 'http://some_url' }
    active { true }
  end
end
