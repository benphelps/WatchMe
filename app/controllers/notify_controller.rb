class NotifyController < ApplicationController

  

  def handle
    if params[:key] == Settings.notify_key
      if params[:name] and params[:event] and params[:call]
        @stream = Stream.friendly.find(params[:name])
        if @stream
          if params[:event] == 'start'
            if params[:call] == 'play'
              @stream.add_viewer
            elsif params[:call] == 'publish'
              @stream.go_live
            end
          elsif params[:event] == 'stop'
            if params[:call] == 'play'
              @stream.remove_viewer
            elsif params[:call] == 'publish'
              @stream.go_dark
            end
          end
          render json: params
          return
        end
      end
    end
    render :nothing => true, :status => 500
  end
  
end
