FactoryBot.define do
  factory :rule do
    user_id { 12_345_678 }
    access_token { 'EAAUiZCczYw5wBAGuok0kUz9IHlLZAxG' }
    campaign_id { 1 }
    sequence(:flimper_back_rule_id) { |n| "#{n}" }
  end
end
