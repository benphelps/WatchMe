class Message < ActiveRecord::Base

  belongs_to :user
  belongs_to :stream
  
  validates_presence_of :user
  validates_presence_of :message

end
