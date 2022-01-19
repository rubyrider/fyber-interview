require 'socket'

module Clients
  class Users
    attr :user_id
    
    def initialize(user_id)
      @user_id = user_id
    end
    
    def start_server!
      Servers::EventSource.start_user_server!
    end
    
    def connection
      @connection ||= TCPSocket.open('localhost', 9801) do |socket|
        socket.puts "#{user_id}\n"
      end
      
    rescue
      @connection = nil
    end
  end
end
