module Journeta
  
  class DefaultPeerHandler
    
    include Logger
    
    def handle(message)
      putsd("New message received! #{message}")
    end
    
  end
  
end