#!/usr/bin/env ruby

require "csv"
require "icalendar"

unless file = ARGV[0]
  puts __FILE__ + " filename"
  exit
end

calendar = Icalendar.parse File.open(file)

CSV.open("#{file}.csv", "wb") do |csv|

  csv << ["DTSTART", "DTEND", "DURATION (H)", "SUMMARY", "DESCRIPTION", "LOCATION", "ORGANIZER", "ATTENDEE"]

  calendar.first.events.each do |event|
    if event.dtstart.is_a?(Icalendar::Values::DateTime) && event.dtend.is_a?(Icalendar::Values::DateTime)
      duration = (event.dtend - event.dtstart) / 1.hour
    end

    attendee = event.attendee.map { |attendee| attendee.to_s }.join(", ")
    csv << [event.dtstart, event.dtend, duration, event.summary, event.description, event.location, event.organizer, attendee]
  end
  
end
