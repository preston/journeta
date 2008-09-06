module Journeta
  
  module Common
    
    class DummyPeerHandler
      def call(message)
        # Intentionally ingore all messages.
      end
    end
    
  end
  
end