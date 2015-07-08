#!/usr/bin/env ruby

require 'colorize'
require 'json'
require 'hipchat'

# Set environment
token = ENV['HIPCHAT_AUTH_TOKEN']
room = ENV['HIPCHAT_ROOM']
from = (ENV['HIPCHAT_FROM'] || `hostname`.strip.upcase).slice(0..14)
message = ARGV[0] || ENV['NOTIFIER_MESSAGE'] || ENV['MESSAGE']
attachment = ENV['NOTIFIER_FILE_ATTACHMENT'] || ENV['FILE_ATTACHMENT']
severity = ARGV[1] || ENV['NOTIFIER_SEVERITY'] || ENV['MSG_SEVERITY']

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
  STDERR.puts "HIPCHAT_AUTH_TOKEN envrionment variable must be set".colorize(:red)
  exit 1
end
if room.nil? || room == ''
  STDERR.puts "HIPCHAT_ROOM envrionment variable must be set".colorize(:red)
  exit 1
end
if message.nil? || message == ''
  STDERR.puts "NOTIFER_MESSAGE envrionment variable must be set or passed as first argument".colorize(:red)
  exit 1
end
unless attachment.nil? || attachment == '' || File.exists?(attachment)
  STDERR.puts "Unable to find file attachment specified in NOTIFIER_FILE_ATTACHMENT environment variable".colorize(:red)
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
  STDERR.puts "failed.".colorize(:red)
  STDERR.puts e.message
  fail
end
