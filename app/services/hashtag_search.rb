class HashtagSearch
  INSTAGRAM_ENDPOINT = 'https://graph.facebook.com/v3.2'.freeze
  LIMIT_PAGE = 50
  FIELDS = %w[id
              media_type
              comments_count
              permalink
              media_url
              like_count
              caption
              children{id,media_type,media_url,permalink}].join(',')

  def self.matching_posts(rule_id)
    rule = Rule.find(rule_id)
    hashtag_response = hashtag_search(rule).with_indifferent_access
    hashtag_id = hashtag_response['data'].try(:first)['id']
    hashtag_posts = hashtag_posts(hashtag_id, rule)
    hashtag_posts
  end

  def self.hashtag_search(rule)
    hashtag = rule.hashtags.first
    encode_url = URI.encode(hashtag)
    url = "#{INSTAGRAM_ENDPOINT}/ig_hashtag_search?user_id=#{rule.user_id}&q=#{encode_url}"
    resource_media(url, rule.access_token)
  end

  def self.hashtag_posts(hashtag_id, rule)
    url = "#{INSTAGRAM_ENDPOINT}/#{hashtag_id}/recent_media"
    posts = resource_media("#{url}?user_id=#{rule.user_id}&fields=#{FIELDS}&limit=#{LIMIT_PAGE}",
                           rule.access_token)
    reduced_posts = posts['data'].map do |p|
      { id: p['id'],
        caption: p['caption'],
        media_type: p['media_type'],
        media_url: p['media_url'],
        children: p['children'],
        permalink: p['permalink'] }.with_indifferent_access
    end
    reduced_posts
    # Si es la primer request entonces guardar el id del post a nivel de la rule (y no hacer nada)
    # Luego (30 minutos despues) hacer la proxima request de posts hasta encontrar el post_id
    # guardado en la rule (ultimo post procesado)
    # Si la response trae un next_page entonces seguir haciendo las requests para pedir los posteos
  end

  def self.resource_media(url, access_token)
    response = Faraday.get(url, access_token: access_token)
    raise ThirdPartyApiError.new({ url: url, message: response.body }, response.status) if response.status != 200

    json_response = JSON.parse response.body
    json_response.with_indifferent_access
  end
end
