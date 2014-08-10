class LastFm < ActiveRecord::Base
  
  def self.recent(user)
    Rails.cache.fetch([user, 'lastfm'], :expires_in => 5.seconds) do
      json = HTTParty.get("http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&limit=2&user=#{user}&api_key=b002d72c627d2b046f7326a31c069f7d&format=json")
      json.parsed_response
    end
  end
  
  def self.nowplaying(user)
    recent = recent(user)
    if recent['recenttracks']['track'][0]
      return {
        playing: ( recent['recenttracks']['track'][0]['@attr'] && recent['recenttracks']['track'][0]['@attr']['nowplaying'] ? true : false ),
        name: recent['recenttracks']['track'][0]['name'],
        artist: recent['recenttracks']['track'][0]['artist']['#text'],
        album: recent['recenttracks']['track'][0]['album']['#text'],
        image: recent['recenttracks']['track'][0]['image'].last['#text']
      }
    else
      return {
        playing: false
      }
    end
    
  end
  
end
