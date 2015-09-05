#!/usr/bin/env ruby

require 'colorize'

# Extract environment variables
services = (ENV['NOTIFIER_SERVICES'] || '').split(',').map(&:strip).map(&:downcase) || []

# Print warning if no notifiers specified
STDERR.puts 'No notifier services specified; use the NOTIFIER_SERVICES environment variable to set them.'.colorize(:yellow) unless services.size > 0

# Send to each service requested
load File.join(File.dirname(__FILE__), 'console-notify')
load File.join(File.dirname(__FILE__), 'slack-notify') if services.include?('slack')
load File.join(File.dirname(__FILE__), 'hipchat-notify') if services.include?('hipchat')
load File.join(File.dirname(__FILE__), 'mailgun-notify') if services.include?('mailgun')
