# frozen_string_literal: true
require 'socket'

module Servers
  class EventSource
    attr_reader :port
    
    def self.start!
      new.start!
    end
    
    def initialize
      @port = 9800
    end
    
    def start!
      start_event_source_server!
    end
    
    def start_event_source_server!
      Thread.new do
      TCPServer.open('localhost', port) do |server|
        loop do
          Thread.start(server.accept) do |client|
            while (message = client.gets&.chomp)
              puts "Received: #{message}"
              case message
              when 'Ping!'
                client.puts 'Pong!'
              when 'quit'
                client.puts 'Quitting!'
                client.close
              else
                client.puts message
              end
            end
            end
          end
        end
      end
    end
  end
end
