class VodsController < ApplicationController
  
  def index
    @vods = Stream.friendly.find(params[:name]).vods
  end
  
  def show
    @vods = Stream.friendly.find(params[:name]).vods
    @vod = @vods.find(params[:id])
  end
  
end
