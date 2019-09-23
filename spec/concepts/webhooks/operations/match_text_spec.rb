# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Webhooks::Operations::MatchText do

  it 'succesfully matches text with words and hashtags' do
    result = Webhooks::Operations::MatchText.run!(text_to_match: 'test text #yolo', words: ['test'], hashtags: ['yolo'])
    expect(result).to eq true
  end

  it 'does not match with words' do
    result = Webhooks::Operations::MatchText.run!(text_to_match: 'test text', words: ['meme'], hashtags: ['yolo'])
    expect(result).to eq false
  end

  it 'does not match with hashtags' do
    result = Webhooks::Operations::MatchText.run!(text_to_match: 'test text', words: ['test'], hashtags: ['yolo'])
    expect(result).to eq false
  end
end
