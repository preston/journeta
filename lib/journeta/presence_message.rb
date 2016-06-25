module Journeta

   # A built-in data structure which gets broadcast across the network
   # for meta-data exchange purposes. A no-frills PORO.
   class PresenceMessage

      attr_accessor :version
      attr_accessor :uuid
      attr_accessor :peer_port

      # An Array of strings. May be empty but not nil. Ex: ['quick_chat', 'Preston Demo 1']
      attr_accessor :groups

      def initialize(uuid, peer_port, groups = [])
         @version = Journeta::VERSION
         @uuid = uuid
         @peer_port = peer_port
         @groups = groups
      end

   end

end
