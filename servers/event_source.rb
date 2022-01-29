# frozen_string_literal: true
require 'socket'
require_relative "./../events/message"

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
    
    def handle_message(message, client)
      puts "Received: #{message}"
      case message
      when 'Ping!'
        client.puts 'Pong!'
      when 'quit'
        client.puts 'Quitting!'
        client.close
      else
        ::Events::Message.new(message).process
      end
    end
    
    def start_event_source_server!
      Thread.new do
        begin
          TCPServer.open('localhost', port) do |server|
          loop do
            Thread.start(server.accept) do |client|
              while (message = client.gets&.chomp)
                handle_message(message, client)
              end
            end
          end
          end
        rescue Errno::EADDRINUSE
          retry
        rescue => e
          puts e.backtrace
        end
      end
    end
  end
end
