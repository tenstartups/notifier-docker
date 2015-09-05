#!/usr/bin/env ruby

require 'colorize'

# Set environment
message = ARGV[0] || ENV['NOTIFIER_MESSAGE'] || ENV['MESSAGE']
severity = ARGV[1] || ENV['NOTIFIER_SEVERITY'] || ENV['MSG_SEVERITY']

if message.nil? || message == ''
  STDERR.puts 'Envrionment variable NOTIFIER_MESSAGE must be set or passed as first argument'.colorize(:red)
  exit 1
end

# Convert severity to a notice color
color = case severity
        when 'info'
          :gray
        when 'success'
          :green
        when 'warn'
          :yellow
        when 'error'
          :red
        else
          :purple
        end

# Print out the message
puts message.colorize(color)
