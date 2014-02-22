class Message < ActiveRecord::Base

  belongs_to :user
  belongs_to :stream
  
  validates_presence_of :user
  validates :message, presence: true, length: { maximum: 120 }

end
