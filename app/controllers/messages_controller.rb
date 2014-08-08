class MessagesController < ApplicationController

  before_action :authenticate_user!

  def create
    @message_text = ActionController::Base.helpers.strip_tags(params[:message][:message])
    @message = Message.new(stream_id: params[:message][:stream_id], user_id: current_user.id, message: @message_text)
    if @message.save
      Danthes.publish_to(
        "/stream/#{params[:message][:stream_id]}",
        type: 'message',
        id: @message.id,
        user_id: current_user.id,
        username: current_user.username,
        message: @message_text.emojify,
        color: current_user.settings(:chat).color
      )
    end
    render nothing: true
  end

end