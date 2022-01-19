require 'rubygems'
require 'bundler/setup'
require "test/unit"
require 'byebug'
require 'socket'

require_relative './../servers/event_source'

class ServerTest < Test::Unit::TestCase
  def test_server_port
    server = Servers::EventSource.new
    
    assert_equal server.port, 9800
  end
  
  def start_server
    Servers::EventSource.start!
  end
  
  def test_server_ping
    Thread.new { start_server }
    
    output = TCPSocket.open("localhost", 9800) do |socket|
      socket.puts "Ping!"
      socket.gets.chomp
    end

    assert_equal output, 'Pong!'
  end
end
