module Journeta
  
  class DefaultPeerHandler
    
    include Logger
    
    def call(message)
      putsd("New message received! #{message}")
    end
    
  end
  
end