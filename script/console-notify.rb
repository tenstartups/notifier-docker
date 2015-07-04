#!/usr/bin/env ruby

require 'colorize'

# Set environment
message = ARGV[0] || ENV['MESSAGE']
severity = ENV['MSG_SEVERITY'] || ARGV[1]

if message.nil? || message == ''
  STDERR.puts "Envrionment variable MESSAGE must be set or passed as first argument".colorize(:red)
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
