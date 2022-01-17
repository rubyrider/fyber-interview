require 'rubygems'
require "bundler/setup"
require 'test-unit'
require './servers/event_source'

class ServerTest< Test::Unit::TestCase
  def event_source_start
    event_source = Servers::EventSource.start!
    
    
  end
end
