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

end
