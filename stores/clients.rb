module Stores
  class Clients
    attr_reader :client, :id
    attr_accessor :connected

    def initialize(id, client)
      @id = id
      @client = client
    end
    
    def broadcast(message)
      client.puts(message)
    end
    
    def connected?
      @connected
    end
    
    class << self
      def stores
        Thread.current[:clients] || {}
      end
      
      def count
        Thread.current[:clients].size
      end
  
      def list
        stores
      end
  
      def get(user_id)
        new(user_id, stores[user_id])
      end
  
      def add(user_id, client)
        stores[user_id] ||= client
        
        new(user_id, client)
      end
      
      alias_method(:find_or_add, :add)
  
      def remove(user_id)
        stores.delete(user_id)
      end
    end
  end
end
