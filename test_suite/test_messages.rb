require 'rubygems'
require 'bundler/setup'
require "test/unit"
require 'byebug'
require 'socket'

require_relative './../stores/clients'
require_relative './../servers'

class ServerTest < Test::Unit::TestCase
  def test_server_port
    server = Servers::EventSource.new
    
    assert_equal server.port, 9800
  end
  
  def start_server
    Servers::EventSource.start!
    Servers::UserServer.start!
  end
  
  def test_event_server_ping
    Thread.new { start_server }
    
    output = TCPSocket.open('localhost', 9800) do |socket|
      socket.puts "Ping!"
      socket.gets.chomp
    end

    assert_equal output, 'Pong!'
  end
  
  def test_user_server_ping
    Thread.new { start_server }
    
    output = TCPSocket.open('localhost', 9801) do |socket|
      socket.puts "Ping!"
      socket.gets.chomp
    end

    assert_equal output, 'PongForUser'
  end
  
  def test_user_connection
    Thread.new { Servers::UserServer.start! }
  
    output = TCPSocket.open('localhost', 9801) do |socket|
      socket.puts "123\n"
      socket.gets&.chomp
    end
  
    assert_equal output, 'Connection accepted for the user##123'
    assert_equal Stores::Clients.count, 1
  end
end

require_relative 'event_message_test'
