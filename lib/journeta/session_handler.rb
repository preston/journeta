module Journeta
  
  class DefaultSessionHandler
    
    include Logger
    
    def handle(message)
      putsd("New message received! #{message}")
    end
    
  end
  
end