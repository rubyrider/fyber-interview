# frozen_string_literal: true

require 'socket'

module Servers
  class EventSource
    attr_reader :server
    
    def self.start!
      new.start!
    end
    
    def initialize
      @server = TCPServer.open('localhost', 9800)
    end
    
    def start!
      loop do
        event_source_connection = server.accept
        
        Thread.start(event_source_connection) do |connection|
          connection.puts("Pong")
          connection.puts("Closing the connection with #{event_source_connection}")
          connection.close
        end
      end
    end
  end
end
