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
  
  def add_viewer
    self.viewers = self.viewers + 1
    self.save
  end

  def remove_viewer
    if self.viewers >= 1
      self.viewers = self.viewers - 1
      self.save
    end
  end
  
  def go_live
    self.live = true
    self.save
  end
  
  def go_dark
    self.live = false
    self.save
  end

end
