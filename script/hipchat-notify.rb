#!/usr/bin/env ruby

require 'awesome_print'
require 'json'
require 'hipchat'

# Set environment
token = ENV['HIPCHAT_AUTH_TOKEN']
room = ENV['HIPCHAT_ROOM']
from = (ENV['HIPCHAT_FROM'] || `hostname`.strip.upcase).slice(0..14)
message = ARGV[0] || ENV['MESSAGE']
attachment = ENV['FILE_ATTACHMENT']
severity = ENV['MSG_SEVERITY'] || ARGV[1]

# Convert severity to a notice color
color = case severity
        when 'info'
          'gray'
        when 'success'
          'green'
        when 'warn'
          'yellow'
        when 'error'
          'red'
        else
          'purple'
        end

# Exit with error if required variables not provided
if token.nil? || token == ''
  puts "HIPCHAT_AUTH_TOKEN envrionment variable must be set"
  exit 1
end
if room.nil? || rooom == ''
  puts "HIPCHAT_ROOM envrionment variable must be set"
  exit 1
end
if message.nil? || message == ''
  puts "MESSAGE envrionment variable must be set or passed as first argument"
  exit 1
end
unless attachment.nil? || attachment == '' || File.exists?(attachment)
  puts "Unable to find file attachment specified in FILE_ATTACHMENT environment variable"
  exit 1
end

# Initialize parameters
params = { message_format: 'text', color: color }

# Add attachments
if attachment.nil? || attachment == ''
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
