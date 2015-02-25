#!/usr/bin/env ruby

require 'awesome_print'
require 'json'
require 'hipchat'

# Set environment
token=ENV['HIPCHAT_AUTH_TOKEN']
room = ENV['HIPCHAT_ROOM']
from = (ENV['HIPCHAT_FROM'] || `hostname`.strip.upcase).slice(0..14)
message = ENV['MESSAGE'] || ARGV[0]
color = ENV['NOTICE_COLOR'] || ''
attachment = ENV['FILE_ATTACHMENT']

# Exit with error if required variables not provided
puts "HIPCHAT_AUTH_TOKEN envrionment variable must be set" and exit 1 unless token
puts "HIPCHAT_ROOM envrionment variable must be set" and exit 1 unless room
puts "MESSAGE envrionment variable must be set or passed as first argument" and exit 1 unless message
puts "Unable to find file attachment specified in FILE_ATTACHMENT environment variable" and exit 1 unless attachment.nil? || File.exists?(attachment)

# Initialize parameters
params = { message_format: 'text', color: color }

# Add attachments
if attachment.nil?
  printf "Sending notification to hipchat room... "
else
  printf "Sending notification to hipchat room with file attachment... "
  message = "#{message}\n\n#{File.open(attachment, 'r') {|f| f.read}}"
end

# Send to Hipchat
begin
  client=HipChat::Client.new(token)
  client[room].send(from, message, params)
  puts "done."
rescue => e
  puts "failed."
  ap e
  raise
end
