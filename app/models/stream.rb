class Stream < ActiveRecord::Base

  extend FriendlyId
  include Bootsy::Container
  
  mount_uploader :placeholder, PlaceholderUploader
  
  validates_presence_of :name
  validates_presence_of :description
  
  belongs_to :user
  has_many :messages
  delegate :username, to: :user
    
  friendly_id :username, use: :slugged
  
  has_many :vods
  has_many :subscriptions
  
  def markdown
    Kramdown::Document.new(body).to_html.html_safe
  end
  
  def go_live(client_id, client_ip)
    self.live = true
    self.viewers = 0
    self.client_id = client_id
    self.client_ip = client_ip
    save
  end
  
  def go_dark
    self.live = false
    self.viewers = 0
    save
  end
  
  def add_viewer
    self.viewers += 1
    save
  end
  
  def remove_viewer
    self.viewers -= 1
    save
  end

end
