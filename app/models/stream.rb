class Stream < ActiveRecord::Base
  extend FriendlyId
  
  belongs_to :user
  has_many :messages
  delegate :username, to: :user
    
  friendly_id :username, use: :slugged

end
