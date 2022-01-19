module Servers
  class UserServer
    attr_reader :port, :stores
    
    def initialize
      @port   = 9801
      @stores = Stores::Clients.stores
    end
    
    def self.start!
      new.start_user_server!
    end
    
    def handle_user_clients(message, client)
      return client.close unless message.match?(/\d+/)
      
      ::Stores::Clients.find_or_add(message, client)
      
      client.puts "Connection accepted for the user###{message}"
    end
    
    def start_user_server!
      Thread.new do
        begin
          TCPServer.open('localhost', port) do |server|
            loop do
              Thread.start(server.accept) do |client|
                while (message = client.gets&.chomp)
                  case message
                  when 'Ping!'
                    client.puts "PongForUser"
                  when 'quit'
                    client.puts 'Quitting!'
                    client.close
                  else
                    handle_user_clients(message, client)
                  end
                end
              end
            end
          end
        rescue
          retry
        end
      end
    end
  end
end
