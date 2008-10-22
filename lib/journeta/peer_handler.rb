module Journeta
  
  class DefaultPeerHandler
    include Logger
    
    def call(message)
      putsd("New message received! #{message}")
    end
    
  end
  
  class DefaultPeerRegisteredHandler
    include Logger
    def call(peer)
      return if peer.nil? or peer.uuid.nil?
      putsd("Peer registration event handled! #{peer.uuid}")
    end    
  end
  
  class DefaultPeerUpdatedHandler
    include Logger
    def call(peer)
      return if peer.nil? or peer.uuid.nil?
      putsd("Peer update event handled! #{peer.uuid}")
    end    
  end
  
  class DefaultPeerUnregisteredHandler
    include Logger
    def call(peer)
      return if peer.nil? or peer.uuid.nil?
      putsd("Peer unregistration event handled! #{peer.uuid}")
    end    
  end
  
end