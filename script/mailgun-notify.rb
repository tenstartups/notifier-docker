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
puts "Envrionment variable MAILGUN_API_KEY must be set" and exit 1 unless api_key
puts "Envrionment variable MAILGUN_DOMAIN must be set" and exit 1 unless domain
puts "Envrionment variable MAILGUN_TO must be set" and exit 1 unless recipient
puts "Envrionment variable MESSAGE must be set or passed as first argument" and exit 1 unless message
puts "Unable to find specified file attachment" and exit 1 unless attachment.nil? || File.exists?(attachment)

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
