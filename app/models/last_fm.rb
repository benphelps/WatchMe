class LastFm < ActiveRecord::Base
  
  
  
  def self.nowplaying(user)
    recent = recent(user)
    if recent['recenttracks']['track'][0]
      return {
        playing: ( recent['recenttracks']['track'][0]['@attr'] && recent['recenttracks']['track'][0]['@attr']['nowplaying'] ? true : false ),
        name: recent['recenttracks']['track'][0]['name'],
        artist: recent['recenttracks']['track'][0]['artist']['#text'],
        album: recent['recenttracks']['track'][0]['album']['#text'],
        image: recent['recenttracks']['track'][0]['image'].last['#text'],
        amazon: amazon(recent['recenttracks']['track'][0]['name'], recent['recenttracks']['track'][0]['artist']['#text'])
      }
    else
      return {
        playing: false
      }
    end
  end
  
  def self.recent(user)
    Rails.cache.fetch([user, 'lastfm'], :expires_in => 5.seconds) do
      json = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&limit=2&user=#{user}&api_key=b002d72c627d2b046f7326a31c069f7d&format=json")
      json.parsed_response
    end
  end
  
  def self.amazon(title, artist)
    res = Rails.cache.fetch([title, artist, 'amazon'], :expires_in => 1.day) do
      query_amazon(title, artist)
    end
  end
  
  def self.query_amazon(title, artist)
    req = Vacuum.new
    req.configure(
        aws_access_key_id: 'AKIAIDVPM7IPNSX2GB2Q',
        aws_secret_access_key: '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',
        associate_tag: 'watchio0c-20'
    )
    res = req.item_search(query: {
      'SearchIndex' => 'DigitalMusic',
      'Keywords'    => "#{title}, #{artist}"
    }).to_h
    if res['ItemSearchResponse']['Items']['TotalResults'].to_i >= 1
      res['ItemSearchResponse']['Items']['Item'][0]['DetailPageURL'].to_s
    else
      false
    end
  end
  
  
end
