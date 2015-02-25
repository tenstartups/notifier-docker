#!/usr/bin/env ruby

require 'awesome_print'
require 'json'
require 'rest_client'

# Set environment
message = ENV['MESSAGE'] || ARGV[0]
hostname = `hostname`
domain = ENV['MAILGUN_DOMAIN']
api_key = ENV['MAILGUN_API_KEY']
send_to = ENV['MAILGUN_TO']
send_from = ENV['MAILGUN_FROM']
attachment_file = ENV['FILE_ATTACHMENT']

# Exit with error if required variables not provided
puts "Envrionment variable MESSAGE must be set or passed as first argument" and exit 1 unless message
puts "Envrionment variable MAILGUN_DOMAIN must be set" and exit 1 unless domain
puts "Envrionment variable MAILGUN_API_KEY must be set" and exit 1 unless api_key
puts "Envrionment variable MAILGUN_TO must be set" and exit 1 unless send_to
puts "Unable to find specified file attachment" and exit 1 unless attachment_file.nil? || File.exists?(attachment_file)

# Set default from if not specified
send_from ||= "#{hostname}@#{domain}"

if attachment_file.nil?

  begin
    printf "Sending notification to mailgun email... "
    response = RestClient.post(
      "https://api.mailgun.net/v2/#{domain}/messages",
      'Authorization': "Bearer #{api_token}",
      params: {
        from: send_from,
        to: send_to,
        subject: message,
        text: message,
        html: message
    )
    puts "done."
  rescue => e
    raise unless e.respond_to?(:response)
    ap JSON.parse(e.response.to_str)
    raise
  end

else

  begin
    printf "Sending notification to mailgun email with file attachment... "
    response = RestClient.post(
      "https://api.mailgun.net/v2/#{domain}/messages",
      'Authorization': "Bearer #{api_token}",
      params: {
        from: send_from,
        to: send_to,
        subject: message,
        text: message,
        html: message,
        attachment: attachment_file
    )
    puts "done."
  rescue => e
    raise unless e.respond_to?(:response)
    ap JSON.parse(e.response.to_str)
    raise
  end

end
