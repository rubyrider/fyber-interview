module Events
  attr_reader :sequence, :type, :from_user_id, :to_user_id
  
  class Message
    
    VALID_TYPES = %w[F U B P S]
    
    def initialize(event)
      @event                 = event
      self.assign_attributes = event
    end
    
    def process
      case @type
      when 'F'
        Stores::Clients.follows[@from_user_id] ||= []
        Stores::Clients.follows[@from_user_id] << @to_user_id
        to_user.broadcast "Followed by #{@from_user_id}"
      when 'U'
        (Stores::Clients.follows[@from_user_id] || []).delete_if {|user_id| user_id == @to_user_id}
      when 'B'
        Stores::Clients.all.each {|user| user.broadcast "Broadcasted" }
      when 'P'
        to_user.puts "Received Private Message by #{@from_user_id}"
      when 'S'
        follows.each {|follower_id| Stores::Clients.get(follower_id).broadcast('Status Updates') }
      else
        puts "Invalid message!"
      end
    end
    
    def follows
      @follows ||= (Stores::Clients.follows[@from_user_id] || [])
    end
    
    def valid?
      @valid ||= VALID_TYPES.include?(@type)
    end
    
    def assign_attributes=(data)
      @sequence, @type, @from_user_id, @to_user_id = data.split(/\|/)
    end
    
    def to_user
      @to_user ||= Stores::Clients.get(@to_user_id)
    end
    
    private
  
      def user_connection
        begin
          @user_connection ||= TCPSocket.open('localhost', 9801)
        rescue
          retry
        end
      end
  end
end
