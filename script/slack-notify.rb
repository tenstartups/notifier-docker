#!/usr/bin/env ruby

require 'colorize'
require 'json'
require 'slack-notifier'

# Set environment
webhook_url = ENV['NOTIFIER_SLACK_WEBHOOK_URL'] || ENV['SLACK_WEBHOOK_URL']
sender = ENV['NOTIFIER_SENDER'] || ENV['USERNAME'] || `hostname`.strip
message = ARGV[0] || ENV['NOTIFIER_MESSAGE'] || ENV['MESSAGE']
attachment = ENV['NOTIFIER_FILE_ATTACHMENT'] || ENV['FILE_ATTACHMENT']
severity = ARGV[1] || ENV['NOTIFIER_SEVERITY'] || ENV['MSG_SEVERITY']
sender = "#{sender} (#{severity})" unless severity.nil? || severity == ''

# Convert severity to a notice color
emoji = case severity
        when 'info'
          ENV['NOTIFIER_SLACK_INFO_EMOJI'] || ':blue_heart:'
        when 'success'
          ENV['NOTIFIER_SLACK_SUCCESS_EMOJI'] || ':green_heart:'
        when 'warn', 'warning'
          ENV['NOTIFIER_SLACK_WARN_EMOJI'] || ':yellow_heart:'
        when 'error', 'failure'
          ENV['NOTIFIER_SLACK_ERROR_EMOJI'] || ':broken_heart:'
        else
          ENV['NOTIFIER_SLACK_DEFAULT_EMOJI'] || ':purple_heart:'
        end

# Exit with error if required variables not provided
if webhook_url.nil? || webhook_url == ''
  STDERR.puts "NOTIFIER_SLACK_WEBHOOK_URL envrionment variable must be set".colorize(:red)
  exit 1
end
if message.nil? || message == ''
  STDERR.puts "NOTIFIER_MESSAGE envrionment variable must be set or passed as first argument".colorize(:red)
  exit 1
end
unless attachment.nil? || attachment == '' || File.exists?(attachment)
  STDERR.puts "Unable to find file attachment specified in NOTIFIER_FILE_ATTACHMENT environment variable".colorize(:red)
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
  notifier=Slack::Notifier.new(webhook_url, username: sender)
  notifier.ping(message, params)
  puts "done."
rescue => e
  STDERR.puts "failed.".colorize(:red)
  STDERR.puts e.message
  fail
end
