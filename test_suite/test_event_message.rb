require 'rubygems'
require 'bundler/setup'
require "test/unit"
require 'byebug'
require_relative './../tcp-server'
require_relative './../events/message'

class TestEventMessage < Test::Unit::TestCase
  def test_invalid_message
    message = Events::Message.new('abc')
    assert_false message.valid?
  end
  
  def test_valid_message
    message = Events::Message.new('12|B')
    
    assert_true  message.valid?
  end

  def test_a_user_follows_message
    TcpServer.new.connect_user 36
    TcpServer.new.connect_user 12
    
    check_client_count 2
    
    message = Events::Message.new('100|F|12|36')
    message.process

    assert_true Stores::Clients.follows['12'].include?('36')
  end

  def test_a_user_unfollows_message
    TcpServer.new.connect_user 36
    TcpServer.new.connect_user 12
    
    check_client_count 2
    
    message = Events::Message.new('100|F|12|36')
    message.process

    message = Events::Message.new('101|U|12|36')
    message.process

    assert_false Stores::Clients.follows['12'].include?('36')
  end
  
  private
  
    def check_client_count(expectation = 1)
      sleep 0.1
    
      assert_equal Stores::Clients.count, expectation
    end
end
