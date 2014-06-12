class HomeController < ApplicationController

  def index
    if user_signed_in?
      redirect_to streams_path
    end
  end

end
