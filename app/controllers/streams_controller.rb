require 'securerandom'
class StreamsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show, :popout]
  before_action :authenticate_stream!, only: [:update]

  def index
    @streams = Stream.all
  end

  def new
    if current_user.stream
      redirect_to current_user.stream
    end
    @stream = Stream.new
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
    else
      render action: 'new'
    end
  end
  
  def edit
    @stream = current_user.stream
  end
  
  def update
    @stream = current_user.stream
    if @stream.update(stream_params)
      respond_to do |format|
        format.html { redirect_to @stream, success: 'Your stream was successfully updated.' }
        format.json { render :json => {  name: @stream.name, body: @stream.markdown, markdown: @stream.body  } }
      end
      Danthes.publish_to(
        "/stream/#{@stream.id}",
        type: 'info_update',
        stream: { name: @stream.name, description: @stream.description, markdown: @stream.markdown }
      )
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
  
  def popout
    @stream = Stream.friendly.find(params[:id])
    render :layout => false
  end

  def show
    @stream = Stream.friendly.find(params[:id])
    @owned = user_signed_in? && (current_user.try(:stream) === @stream)
    if user_signed_in?
      gon.push({
        color: current_user.settings(:chat).color
      })
    end
    gon.push({
      stream_id: @stream.id,
      stream_name: @stream.name
    })
  end
  
  def player
    @stream = Stream.friendly.find(params[:id])
    gon.push({
      stream_id: @stream.id,
      stream_name: @stream.name
    })
    render :partial => 'player', :content_type => 'text/html'
  end
  
  def subscribe
    @stream = Stream.find(params[:id])
    sub = Subscription.new(user: current_user, stream: @stream)
  end

  private
  
  def authenticate_stream!
    @stream = Stream.friendly.find(params[:id])
    if current_user.stream != @stream then
      
      respond_to do |format|
        format.html { render text: 'Unauthorized!' }
        format.json { render :json => {error: 'Unauthorized!'} }
      end
    end
  end
  
  def stream_params
    params.require(:stream).permit(:name, :description, :body, :bootsy_image_gallery_id, :placeholder)
  end

end
