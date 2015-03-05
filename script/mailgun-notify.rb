#!/usr/bin/env ruby

require 'awesome_print'
require 'json'
require 'rest_client'

# Set environment
api_key = ENV['MAILGUN_API_KEY']
domain = ENV['MAILGUN_DOMAIN']
sender = ENV['MAILGUN_FROM'] || "#{`hostname`.strip}@#{domain}"
recipient = ENV['MAILGUN_TO']
message = ENV['MESSAGE'] || ARGV[0]
attachment = ENV['FILE_ATTACHMENT']

# Exit with error if required variables not provided
if api_key.nil?
  puts "Envrionment variable MAILGUN_API_KEY must be set"
  exit 1
end
if domain.nil?
  puts "Envrionment variable MAILGUN_DOMAIN must be set"
  exit 1
end
if recipient.nil?
  puts "Envrionment variable MAILGUN_TO must be set"
  exit 1
end
if message.nil?
  puts "Envrionment variable MESSAGE must be set or passed as first argument"
  exit 1
end
unless attachment.nil? || File.exists?(attachment)
  puts "Unable to find specified file attachment"
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
if attachment.nil?
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
  puts "failed."
  ap e
  raise
end
