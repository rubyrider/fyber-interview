module Servers
  class UserServer
    attr_reader :port, :clients
    
    def initialize
      @port = 9801
      @clients =->(id) { Stores::Clients.get(id) }
    end
    
    def self.start!
      new.start_user_server!
    end

    def handle_user_clients(message, client)
      return client.close unless message.match?(/\d+/)
      
      client.puts "Connection accepted for the user###{message}"
      
      ::Stores::Clients.find_or_add(message, client)
    end
    
    def start_user_server!
      Thread.new do
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
      end
    end
  end
end
