module InstagramGraph
  module Queries
    class IgMedia < ActiveInteraction::Base
      string :media_id
      string :access_token
      LIMIT_PAGE = 50
      FIELDS = %w[id
                  media_type
                  comments_count
                  permalink
                  media_url
                  like_count
                  caption
                  children{id,media_type,media_url,permalink}].join(',')

      def execute
        unless http_response.success?
          raise ThirdPartyApiError.new({ url: request_url, message: http_response.body }, http_response.code)
        end

        parse_response
      end

      def http_response
        @http_response ||= HTTParty.get(request_url)
      end

      def request_url
        @request_url ||= "https://graph.facebook.com/#{media_id}?fields=#{FIELDS}&access_token=#{access_token}"\
"&limit=#{LIMIT_PAGE}"
      end

      def parse_response
        json_response = JSON.parse(http_response.body)
        json_response.with_indifferent_access
      end
    end
  end
end
