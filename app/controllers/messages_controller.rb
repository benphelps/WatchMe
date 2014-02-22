class MessagesController < ApplicationController

  def fetch
    @messages = Message.find(stream_id: params[:id]).limit 20
  end

  def create
    @message = Message.new(stream_id: params[:message][:stream_id], user_id: current_user.id, message: params[:message][:message])
    if @message.save
      PrivatePub.publish_to "/channel/#{params[:message][:stream_id]}", username: current_user.username, message: CGI::escapeHTML(@message.message)
    end
  end

end
