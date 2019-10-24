# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Webhooks::Operations::MatchText do
  let(:text) { 'test text #yolo' }
  it 'succesfully matches text with words and hashtags' do
    result = Webhooks::Operations::MatchText.run!(text_to_match: text, words: ['test'],
                                                  hashtags: ['yolo'])
    expect(result).to be_truthy
  end

  context 'when only words are present' do
    it 'match words without capital letters' do
      result = Webhooks::Operations::MatchText.run!(text_to_match: text, words: ['test'],
                                                    hashtags: [])
      expect(result).to be_truthy
    end
    it 'match words with capital letters' do
      result = Webhooks::Operations::MatchText.run!(text_to_match: text, words: ['Test'],
                                                    hashtags: [])
      expect(result).to be_truthy
    end
  end

  context 'when only hashtags are present' do
    it 'match hashtags without capital letters' do
      result = Webhooks::Operations::MatchText.run!(text_to_match: text, words: [],
                                                    hashtags: ['yolo'])
      expect(result).to be_truthy
    end
    it 'match hashtags with capital letters' do
      result = Webhooks::Operations::MatchText.run!(text_to_match: text, words: [],
                                                    hashtags: ['Yolo'])
      expect(result).to be_truthy
    end
  end

  it 'does not match with words' do
    result = Webhooks::Operations::MatchText.run!(text_to_match: 'test text', words: ['meme'],
                                                  hashtags: ['yolo'])
    expect(result).to be_falsey
  end

  it 'does not match with hashtags' do
    result = Webhooks::Operations::MatchText.run!(text_to_match: 'test text', words: ['test'],
                                                  hashtags: ['yolo'])
    expect(result).to be_falsey
  end
end
