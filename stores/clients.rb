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
        @stores ||= (Thread.current[:clients] ||= {})
      end
      
      def follows
        @follows ||= (Thread.current[:follows] ||= {})
      end
      
      def reset!
        @stores = (Thread.current[:clients] = {})
        @stores = (Thread.current[:follows] = {})
      end
      
      def count
        stores.size || 0
      end
  
      def list
        stores
      end

      def all
        stores.map {|user_id, client|  new(user_id, client) }
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
