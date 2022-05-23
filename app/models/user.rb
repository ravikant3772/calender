class User
	include Mongoid::Document
	include Mongoid::Timestamps

	field :username,  type: String
  field :email,  type: String
  field :phone,  type: String

  validates :username, presence: true
  validates :email, presence: true
  validates :phone, presence: true

  has_many :user_events, dependent: :destroy

  def self.creater
    User.first
  end
end
