require 'rubygems'
require 'bundler/setup'
require "test/unit"
require 'byebug'

require_relative './../events/message'

class EventMessageTest < Test::Unit::TestCase
  def test_invalid_message
    message = Events::Message.new('abc')
    assert_false message.valid?
  end
  
  def test_valid_message
    message = Events::Message.new('12|B')
    
    assert_true  message.valid?
  end
end
