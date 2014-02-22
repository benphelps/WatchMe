class User < ActiveRecord::Base

  extend FriendlyId
  
  friendly_id :username

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable
  
  validates :username, presence: true
  validates_uniqueness_of :username
  
  has_one :stream
  has_many :messages
         
end
