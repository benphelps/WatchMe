class NotifyController < ApplicationController

  protect_from_forgery except: :handle

  def handle
    # only trusted sources
    if Settings.auth.servers.include?(request.remote_ip)
      if params[:call]
        case params[:call]
          when 'play'
            @stream = Stream.find_by_slug(params[:name])
            if not @stream.nil?
              @stream.add_viewer
            end
            render :nothing => true, :status => 200
          when 'play_done'
            @stream = Stream.find_by_slug(params[:name])
            if not @stream.nil?
              @stream.remove_viewer
            end
            render :nothing => true, :status => 200
          when 'publish'
            @stream = Stream.find_by_slug(params[:name])
            if not @stream.nil?
              if @stream.private_key == params[:key]
                @stream.go_live(params[:clientid], params[:addr])
                render :nothing => true, :status => 200
              else
                render :nothing => true, :status => 500
              end
            else
              render :nothing => true, :status => 500
            end
          when 'publish_done'
            @stream = Stream.where(client_id: params[:clientid], client_ip: params[:addr]).try(:first)
            if not @stream.nil?
              @stream.go_dark
              render :nothing => true, :status => 200
            else
              render :nothing => true, :status => 404
            end
          when 'record_done'
            @stream = Stream.find_by_slug(params[:name])

            @basename = File.basename(params[:path], ".*")
            @date = Time.at(@basename.split('-').last.to_i).strftime('%A, %b %d')
            
            @vod = Vod.create(stream: @stream, title: @date, description: '', basename: @basename)
            @vod.save
            @stream.vods << @vod
            @stream.save
            render :nothing => true, :status => 200
        end
      else
        render :nothing => true, :status => 400
      end
    else
      render :nothing => true, :status => 403
    end
  end
  
end
