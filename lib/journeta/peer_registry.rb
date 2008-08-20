
module Journeta
   
   # responsible for keeping in-memory metadata on known peers,
   # as well as peer tcp connections
   class PeerRegistry << Journeta::Asynchronous
   
      attr_accessor :peers

      def initialize
         @peers = {}
      end
      
      def clear
         h.clear
      end
   
      def add
      
      end
   
   end

end