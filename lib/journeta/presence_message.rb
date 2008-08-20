module Journeta
   
   class PresenceMessage
      
      attr_accessor :version
      attr_accessor :uuid
      attr_accessor :session_port
      attr_accessor :online
      
      def initialize(uuid, session_port, online = true)
         @version = Journeta::VERSION::STRING
         @uuid = uuid
         @session_port = session_port
         @online = online
      end
      
   end
   
end
