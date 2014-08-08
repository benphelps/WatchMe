class SettingsController < ApplicationController
  
  before_action :authenticate_user!
  
  def color
    @color = params[:color]
    if Settings.chat.colors.include? @color
      current_user.settings(:chat).color = @color
      current_user.save
      render json: { status: 'ok' }
    else
      render json: { status: 'fail' }
    end
  end
  
end
