#!/usr/bin/env ruby

# Extract environment variables
services = ENV['NOTIFIER_SERVICES'].split(',').map(&:strip).map(&:downcase) || []

# Exit with error if required variables not provided
puts "No notifier services specified; use the NOTIFIER_SERVICES environment variable to set them." and exit 1 unless services.size > 0

# Send to each service requested
require File.join(File.dirname(__FILE__), 'slack-notify.rb') if services.include?('slack')
require File.join(File.dirname(__FILE__), 'hipchat-notify.rb') if services.include?('hipchat')
require File.join(File.dirname(__FILE__), 'mailgun-notify.rb') if services.include?('mailgun')
