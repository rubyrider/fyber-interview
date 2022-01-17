require 'rubygems'
require 'bundler/setup'

module Servers
  autoload :EventSource, 'servers/event_source'
  autoload :UserClient, 'servers/user_client'
end
