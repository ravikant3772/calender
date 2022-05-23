class UserEvent
	include Mongoid::Document
	include Mongoid::Timestamps

	field :rsvp, type: String, default: 'no'
  validates :rsvp, inclusion: { in: %w(yes no maybe) }

  belongs_to :user
	belongs_to :event

	#callbacks
	before_save :reset_overlapping_rsvp

	# set previous overlapping event's rsvp as no
	def reset_overlapping_rsvp
		UserEvent.where(
			:user_id => self.user_id,
			:event_id.in => get_overlapping_events.map(&:id)
		).update_all(rsvp: 'no')
	end

	private
	# get overlapping vents for this user
	def get_overlapping_events
		event_ids = UserEvent.where(
			:user_id => self.user_id,
			:id.ne => self.id
		).pluck(:event_id)

		Event.where(
			:start_time.gte => self.event.start_time,
			:end_time.lte => self.event.end_time,
			:id.in => event_ids
		)
	end
end
