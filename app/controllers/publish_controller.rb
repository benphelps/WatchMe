class PublishController < ApplicationController

  def publish
    @user = User.find_by_username(params[:name])
    if @user
      @stream = @user.stream
      if @stream.private_key == params[:key]
        render :nothing => true, :status => 200
      else
        render :nothing => true, :status => 500
      end
    else
      render :nothing => true, :status => 500
    end
  end

end
