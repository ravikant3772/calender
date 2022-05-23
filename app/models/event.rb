class Event
	include Mongoid::Document
	include Mongoid::Timestamps

	#table columns
	field :title, type: String
	field :start_time, type: DateTime
	field :end_time, type: DateTime
	field :description, type: String
	field :is_all_day, type: Boolean, default: false
	field :completed, type: Boolean, default: false

	#validations
	validates :title, presence: true
	validates :start_time, presence: true
	validates :start_time, presence: true
	# validate :valid_time_period

	#associations
	belongs_to :created_by, class_name: "User"
	has_many :user_events, dependent: :destroy

	#callbacks
	before_save :set_completed

	#validate start time should be earlier than end time
	def valid_time_period
		if (self.start_time < self.end_time)
			errors.add(:start_time, 'should be earlier than end time')
			return false
		end
		return true
	end

	#return event is completed or not
	def is_completed
		return if self.completed
		if (self.is_all_day)
			self.set(is_completed: true) if self.end_time.date < DateTime.now.date
		else
			self.set(is_completed: true) if self.end_time < DateTime.now
		end
		self.completed
	end

	#callback sets completed flag while saving event
	def set_completed
		if (self.is_all_day)
			self.completed = true if self.end_time.date < DateTime.now.date
		else
			self.completed = true if self.end_time < DateTime.now
		end
	end
end
