module Journeta
  
  module Common
    
    class DummyPeerHandler
      def handle(message)
        # Intentionally ingore all messages.
      end
    end
    
  end
  
end