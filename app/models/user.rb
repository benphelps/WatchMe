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
      :tech => 'hls',
      :volume => 0.50
    }
    s.key :chat, :defaults => {
      color: '000000'
    }
  end
  
  after_create :set_color
  
  def set_color
    generator = ColorGenerator.new saturation: 0.3, lightness: 0.75
    self.settings(:chat).color = generator.create_hex
  end
         
end
