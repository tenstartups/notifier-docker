#!/usr/bin/env ruby

require 'colorize'
require 'json'
require 'rest_client'

# Set environment
api_key = ENV['MAILGUN_API_KEY']
domain = ENV['MAILGUN_DOMAIN']
sender = ENV['MAILGUN_FROM'] || "#{`hostname`.strip}@#{domain}"
recipient = ENV['MAILGUN_TO']
message = ARGV[0] || ENV['NOTIFIER_MESSAGE'] || ENV['MESSAGE']
attachment = ENV['FILE_ATTACHMENT']

# Exit with error if required variables not provided
if api_key.nil? || api_key == ''
  STDERR.puts "Envrionment variable MAILGUN_API_KEY must be set"
  exit 1
end
if domain.nil? || domain == ''
  STDERR.puts "Envrionment variable MAILGUN_DOMAIN must be set"
  exit 1
end
if recipient.nil? || recipient == ''
  STDERR.puts "Envrionment variable MAILGUN_TO must be set"
  exit 1
end
if message.nil? || message == ''
  STDERR.puts "Envrionment variable NOTIFIER_MESSAGE must be set or passed as first argument"
  exit 1
end
unless attachment.nil? || attachment == '' || File.exists?(attachment)
  STDERR.puts "Unable to find specified file attachment".colorize(:red)
  exit 1
end

# Initialize parameters
params = {
  from: sender,
  to: recipient,
  subject: message,
  text: message,
  html: message
}

# Add attachments
if attachment.nil? || attachment == ''
  printf "Sending notification to mailgun email... "
else
  printf "Sending notification to mailgun email with file attachment... "
  params.merge!(attachment: File.new(attachment, 'rb'))
end

# Send to Mailgun
begin
  response = RestClient.post("https://#{api_key}@api.mailgun.net/v2/#{domain}/messages", params)
  puts "done."
rescue => e
  STDERR.puts "failed.".colorize(:red)
  STDERR.puts e.message
  fail
end
