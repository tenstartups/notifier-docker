#!/usr/bin/env ruby

require 'colorize'
require 'json'
require 'slack-notifier'

# Set environment
webhook_url = ENV['SLACK_WEBHOOK_URL']
username = ENV['USERNAME'] || `hostname`.strip
message = ARGV[0] || ENV['MESSAGE']
attachment = ENV['FILE_ATTACHMENT']
severity = ENV['MSG_SEVERITY'] || ARGV[1]
username = "#{username} (#{severity})" unless severity.nil? || severity == ''

# Convert severity to a notice color
emoji = case severity
        when 'info'
          ':blue_heart:'
        when 'success'
          ':green_heart:'
        when 'warn'
          ':yellow_heart:'
        when 'error'
          ':broken_heart:'
        else
          ':purple_heart:'
        end

# Exit with error if required variables not provided
if webhook_url.nil? || webhook_url == ''
  STDERR.puts "SLACK_WEBHOOK_URL envrionment variable must be set".colorize(:red)
  exit 1
end
if message.nil? || message == ''
  STDERR.puts "MESSAGE envrionment variable must be set or passed as first argument".colorize(:red)
  exit 1
end
unless attachment.nil? || attachment == '' || File.exists?(attachment)
  STDERR.puts "Unable to find file attachment specified in FILE_ATTACHMENT environment variable".colorize(:red)
  exit 1
end

# Initialize parameters
params = { icon_emoji: emoji }

# Add attachments
if attachment.nil? || attachment == ''
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
  STDERR.puts "failed.".colorize(:red)
  ap e
  raise
end
