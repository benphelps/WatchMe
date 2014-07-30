class MessagesController < ApplicationController

  before_action :authenticate_user!

  def fetch
    @messages = Message.find(stream_id: params[:id]).limit 20
  end

  def create
    @message = Message.new(stream_id: params[:message][:stream_id], user_id: current_user.id, message: params[:message][:message])
    if @message.save
      Danthes.publish_to(
        "/stream/#{params[:message][:stream_id]}",
        id: @message.id,
        username: current_user.username,
        message: CGI::escapeHTML(@message.message).emojify,
        color: current_user.settings(:chat).color
      )
    end
    render nothing: true
  end

end