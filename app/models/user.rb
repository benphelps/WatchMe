class User < ActiveRecord::Base

  extend FriendlyId
  friendly_id :username

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable
  
  validates :username, presence: true
  validates_uniqueness_of :username
  
  has_one :stream
  has_many :messages
  has_many :subscriptions
  
  has_settings do |s|
    s.key :player, :defaults => {
      :tech => 'flash',
      :volume => 0.50
    }
    s.key :chat, :defaults => {
      color: '000000'
    }
    s.key :lastfm, :defaults => {
      enabled: false,
      username: nil,
    }
  end
  
  after_create :set_color
  
  def set_color
    self.settings(:chat).color = Settings.chat.colors.sample
  end
         
end
