module Events
  attr_reader :sequence, :type, :from_user_id, :to_user_id
  
  class Message
    
    VALID_TYPES = %w[F U B P S]
    
    def initialize(event)
      @event                 = event
      self.assign_attributes = event
    end
    
    def valid?
      @valid ||= VALID_TYPES.include?(@type)
    end
    
    def assign_attributes=(data)
      @sequence, @type, @from_user_id, @to_user_id = data.split(/\|/)
    end
  end
end
