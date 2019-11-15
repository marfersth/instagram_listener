module InstagramGraph
  module Queries
    class MediaCommentOwner < ActiveInteraction::Base
      string :comment_id, default: nil
      string :media_id
      string :access_token

      def execute
        raise http_exception unless http_request.success?

        parse_username
      end

      private

      def post_id
        @post_id ||= comment_id.presence || media_id
      end

      def http_request
        @http_request ||= HTTParty.get(url)
      end

      def url
        @url ||= "https://graph.facebook.com/#{post_id}?fields=username"\
"&access_token=#{access_token}"
      end

      def parse_username
        @parse_username ||= JSON.parse(http_request.body)['username']
      end

      def http_exception
        ThirdPartyApiError.new({ url: url, message: http_request.body }, http_request.code)
      end
    end
  end
end
