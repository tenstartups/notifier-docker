#!/usr/bin/env ruby

require 'awesome_print'
require 'json'
require 'rest_client'

api_token='9a57e098b87b71aa50f30efb1e4eb20c75c8425f1ce989e1c64ab7a83777e99c'

payload = {}

begin
  response = RestClient.get(
    "https://api.digitalocean.com/v2/account/keys",
    'Authorization' => "Bearer #{api_token}",
    :content_type => :json,
    :accept => :json
  )
  ap JSON.parse(response.to_str)
rescue => e
  raise unless e.respond_to?(:response)
  ap JSON.parse(e.response.to_str)
  raise
end



# Send to slack if enabled
if defined?(Slack) && (webhook_url=ENV['SLACK_EVENTS_URL']).present?
  emoji = case opts[:severity].to_sym
    when :debug
      ':purple_heart:'
    when :info
      ':green_heart:'
    when :warn
      ':yellow_heart:'
    when :error
      ':broken_heart:'
  end
  message="@everyone #{message}" if opts[:notify_all]
  notifier=Slack::Notifier.new(webhook_url, username: Settings.app_name)
  notifier.ping(message, icon_emoji: emoji)
end

# Send to HipChat if enabled
if defined?(HipChat) && (token=ENV['HIPCHAT_AUTH_TOKEN']).present? && (room=ENV['HIPCHAT_EVENTS_ROOM']).present?
  color = case opts[:severity].to_sym
    when :debug
      :purple
    when :info
      :green
    when :warn
      :yellow
    when :error
      :red
  end
  message="@all #{message}" if opts[:notify_all]
  client=HipChat::Client.new(token)
  client[room].send(ENV['HIPCHAT_EVENTS_FROM'] || Settings.app_name.slice(1..15), message, message_format: 'text', color: color)
