#!/usr/bin/env ruby

# Extract environment variables
services = ENV['NOTIFIER_SERVICES'].split(',').map(&:strip).map(&:downcase) || []

# Exit with error if required variables not provided
unless services.size > 0
  puts "No notifier services specified; use the NOTIFIER_SERVICES environment variable to set them."
  exit 1
end

# Send to each service requested
load File.join(File.dirname(__FILE__), 'slack-notify') if services.include?('slack')
load File.join(File.dirname(__FILE__), 'hipchat-notify') if services.include?('hipchat')
load File.join(File.dirname(__FILE__), 'mailgun-notify') if services.include?('mailgun')
