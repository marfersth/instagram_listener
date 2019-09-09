# frozen_string_literal: true

require 'uri'

class HookUrlValidator < ActiveModel::Validator
  def validate(record)
    uri = URI.parse(record.hook_url)
    record.errors[:hook_url] << 'Invalid URL' unless uri.is_a?(URI::HTTP)
  rescue URI::InvalidURIError
    record.errors[:hook_url] << 'Invalid URL'
  end
end
