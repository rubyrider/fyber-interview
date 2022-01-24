require 'rubygems'
require 'bundler/setup'
require "test/unit"
require 'byebug'
require 'socket'

require_relative './../stores/clients'
require_relative './../servers'

class TestServers < Test::Unit::TestCase
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
    
    begin
      output = TCPSocket.open('localhost', 9800) do |socket|
        socket.puts "Ping!"
        socket.gets.chomp
      end
    rescue
      retry
    end
    
    assert_equal output, 'Pong!'
  end
  
  def test_user_server_ping
    Thread.new { start_server }
    
    begin
      output = TCPSocket.open('localhost', 9801) do |socket|
        socket.puts "Ping!"
        socket.gets.chomp
      end
    rescue Errno::EADDRINUSE
      retry
    rescue => e
      puts e.message
      puts e.backtrace
    end
    
    assert_equal output, 'PongForUser'
  end
  
  def test_user_connection
    Stores::Clients.reset!
    
    Thread.new { Servers::UserServer.start! }

    begin
      output = TCPSocket.open('localhost', 9801) do |socket|
        socket.puts "123\n"
        socket.gets&.chomp
      end
    rescue Errno::EADDRINUSE
      retry
    rescue => e
      puts e.message
      puts e.backtrace
    end
    
    assert_equal output, 'Connection accepted for the user##123'
    assert_equal Stores::Clients.count, 1
  end
end
