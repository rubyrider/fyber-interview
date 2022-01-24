require 'rubygems'
require 'bundler/setup'

require_relative './servers'
require_relative './clients'

require './stores/clients'

class TcpServer
  def initialize
    Servers::EventSource.start!
    Servers::UserServer.start!
  end
  
  def emit_events(message)
    puts "Emitting message: #{message}"
    event_receiver.puts message
  end
  
  # for only connecting users
  def connect_user(id)
    user_connection.puts "#{id}\n"
  end
  
  private
    
    def event_receiver
      begin
        @event_receiver ||= TCPSocket.open('localhost', 9800)
      rescue
        retry
      end
    end
  
  def user_connection
    begin
      @user_connection ||= TCPSocket.open('localhost', 9801)
    rescue
      retry
    end
  end
end


