require 'rubygems'
require 'bundler/setup'
require "test/unit"
require 'byebug'
require 'socket'

require_relative './../tcp-server'

require_relative 'test_servers'
require_relative 'test_event_message'


class TestTcpServer < Test::Unit::TestCase
  attr_reader :tcp_server
  
  def setup
    Stores::Clients.reset!
    
    @tcp_server ||= ::TcpServer.new
  end
  
  def check_client_count(expectation = 1)
    sleep 0.1
  
    assert_equal Stores::Clients.count, expectation
  end
  
  def test_follow_users
    server = TcpServer.new
    
    server.connect_user 12
    server.connect_user 36
    server.connect_user 50
    
    server.emit_events('100|F|12|36')

    sleep 0.1
    
    assert_true Stores::Clients.follows['12'].include?('36')
    assert_false Stores::Clients.follows['12'].include?('50')
  end
  
  def test_connecting_user
    assert_equal Stores::Clients.count, 0
    
    tcp_server.connect_user(123)
    
    check_client_count

    tcp_server.connect_user(124)
    
    check_client_count 2

    tcp_server.connect_user(124)
    
    check_client_count 2
  end
end
