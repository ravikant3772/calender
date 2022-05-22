class Event
	include Mongoid::Document
	include Mongoid::Timestamps

	field :title, type: String
  field :start_time, type: DateTime
  field :end_time, type: DateTime
  field :description, type: String
  field :is_all_day, type: Boolean, default: false

  validates :title, presence: true
  validates :start_time, presence: true

  belongs_to :created_by, class_name: "User"
  has_many :user_events
end
