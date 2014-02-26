require 'securerandom'
class StreamsController < ApplicationController

  before_action :authenticate_user!, only: [:edit, :update, :new, :create, :info, :fmle]

  def index
    @streams = Stream.all
  end
  
  def new
    if current_user.stream
      redirect_to current_user.stream
    end
    @stream = Stream.new(user: current_user, body: 'You can edit this later.')
  end
  
  def create
    @stream = Stream.new(
      user: current_user,
      name: stream_params[:name],
      description: stream_params[:description],
      body: stream_params[:body]
    )
    @stream.public_key = SecureRandom.hex(6)
    @stream.private_key = SecureRandom.hex(12)
    @stream.user_id = current_user.id
    
    if @stream.save
      redirect_to @stream
    end
  
  end
  
  def edit
    @stream = current_user.stream
  end
  
  def update
    @stream = current_user.stream
    if @stream.update(stream_params)
      redirect_to @stream, notice: 'Your stream was successfully updated.'
    else
      render action: 'edit'
    end
  end
  
  def info
    @stream = current_user.stream
  end
  
  def fmle
    @stream = current_user.stream
    response.headers['Content-Disposition'] = "attachment; filename=watchmeio-#{current_user.username}-fmle.xml"
    render :layout => false
  end
  
  def smil
    @stream = Stream.friendly.find(params[:id])
    render :layout => false
  end

  def show
    @stream = Stream.friendly.find(params[:id])
  end

  private
  
  def stream_params
    params.require(:stream).permit(:name, :description, :body, :bootsy_image_gallery_id, :placeholder)
  end

end
