require 'socket'

module Clients
  class Users
    
    def initialize
      @server = Servers::EventSource.start!
    end
  end
end
