# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'
#seeding user data
puts 'adding user seed data'
CSV.foreach(Rails.root.to_s + '/db/seed_csvs/users.csv', headers: true) do |row|
  user = User.new
  user.username = row['username']
  user.email = row['email']
  user.phone = row['phone']
  user.save!
end
puts 'added user seed data'

#seeding event data
puts 'adding event seed data'
event_creater_id = User.first.id
CSV.foreach(Rails.root.to_s + '/db/seed_csvs/events.csv', headers: true) do |row|
  event = Event.new
  event.title = row['title']
  event.start_time = DateTime.parse(row['starttime'])
  event.end_time = DateTime.parse(row['endtime'])
  event.description = row['description']
  event.is_all_day = row['allday'] == 'TRUE'
  event.created_by_id = event_creater_id
	event.save!

	puts "adding rsvp data for event #{event.title}"
	next if row['users#rsvp'].nil? || row['users#rsvp'].empty?
	rsvp_arr = row['users#rsvp'].split(';')

	#seeding user related rsvp data for current event
	users_rsvp_arr = rsvp_arr.map do |ursvp|
		raw_arr = ursvp.split('#')
		username = raw_arr[0]
		rsvp = raw_arr[1]

		UserEvent.create({
			user_id: User.find_by(username: username),
			rsvp: rsvp,
			event_id: event.id
		})
	end
	puts "added rsvp data for event #{event.title}"

end
puts 'adding event seed data'
