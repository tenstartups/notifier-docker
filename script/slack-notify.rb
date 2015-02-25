#!/usr/bin/env ruby

require 'awesome_print'
require 'json'
require 'slack-notifier'

# Set environment
webhook_url = ENV['SLACK_WEBHOOK_URL']
username = ENV['USERNAME'] || `hostname`.strip
message = ENV['MESSAGE'] || ARGV[0]
emoji = ENV['ICON_EMOJI'] || ''
attachment = ENV['FILE_ATTACHMENT']

# Exit with error if required variables not provided
puts "SLACK_WEBHOOK_URL envrionment variable must be set" and exit 1 unless webhook_url
puts "MESSAGE envrionment variable must be set or passed as first argument" and exit 1 unless message
puts "Unable to find file attachment specified in FILE_ATTACHMENT environment variable" and exit 1 unless attachment.nil? || File.exists?(attachment)

# Initialize parameters
params = { icon_emoji: emoji }

# Add attachments
if attachment.nil?
  printf "Sending notification to slack channel... "
else
  printf "Sending notification to slack channel with file attachment... "
  params.merge!(attachments: [ text: File.open(attachment, 'r') {|f| f.read} ])
end

# Send to Slack
begin
  notifier=Slack::Notifier.new(webhook_url, username: username)
  notifier.ping(message, params)
  puts "done."
rescue => e
  puts "failed."
  ap e
  raise
end
