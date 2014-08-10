class LastfmController < ApplicationController
  def playing
    if params[:id] 
      user = User.find(params[:id])
      if user && user.settings(:lastfm).enabled
        render json: LastFm.nowplaying(user.settings(:lastfm).username)
      else
        render json: { playing: false }
      end
    end
  end
end
