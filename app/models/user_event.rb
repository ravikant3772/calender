class UserEvent
	include Mongoid::Document
	include Mongoid::Timestamps

	field :rsvp, type: String, default: 'no'
  validates :rsvp, inclusion: { in: %w(yes no maybe) }

  belongs_to :user
  belongs_to :event
end
