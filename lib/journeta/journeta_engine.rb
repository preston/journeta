# Copyright © 2007 OpenRain, LLC. All rights reserved.
#
# Preston Lee <preston.lee@openrain.com>


module Journeta
  
  # The primary fascade of the entire +Journeta+ library, which composite a number of objects that may or may not have code running asynchronously to the primary application +Thread+.
  class JournetaEngine
    
    include Logger
    
    # A supposedly universally unique id for this instance.
    attr_reader :uuid
    
    # An array of peer network names. Ex: ['OpenRain Test', 'quick_chat_app']
    # An empty array indicates implicit membership in all discovered groups.
    attr_reader :groups
    
    
    # Continuously sends out "i'm here" presence messages to the local network
    attr_reader :presence_broadcaster
    
    # continuously listens for "i'm here" presence messages from other peers
    attr_reader :presence_listener
    
    # The UDP port for event broadcast messages.
    attr_reader :presence_port
    
    # The UDP network address used for broadcast messages.
    attr_reader :presence_address
    
    # The amount of time between presence broadcasts.
    attr_reader :presence_period
    
    
    
    # Constantly listens for incoming peer sessions
    attr_reader :peer_listener
    
    # Application logic which processes session data.
    attr_reader :peer_handler
    
    # The TCP port used to receive direct peer messages.
    attr_reader :peer_port
    
    # Authoritative peer availability database.
    attr_reader :peer_registry
    
    
    
    
    
    # Incoming direct peer TCP connections will use this port.
    @@DEFAULT_PEER_PORT = 31338
    
    # The application message callback handler.
    @@DEFAULT_PEER_HANDLER = DefaultPeerHandler.new
    
    @@DEFAULT_PRESENCE_PORT = 31337
    
    # Addresses 224.0.0.0 through 239.255.255.255 are reserved for multicast messages.
    @@DEFAULT_PRESENCE_NETWORK = '224.220.221.222'
    
    # The wait time, in seconds, between rebroadcasts of peer presence.
    @@DEFAULT_PRESENCE_PERIOD = 4
    
    
    def initialize(configuration ={})
      putsd "CON: #{configuration}"
      
      # TODO make guaranteed to be unique.
      @uuid = configuration[:uuid] || rand(2 ** 31)
      @groups = configuration[:groups]
      
      
      @peer_port = configuration[:peer_port] || @@DEFAULT_PEER_PORT
      @peer_handler = configuration[:peer_handler] || @@DEFAULT_PEER_HANDLER
      @peer_listener = Journeta::PeerListener.new self
      
      @presence_port = configuration[:presence_port] || @@DEFAULT_PRESENCE_PORT    
      @presence_address = configuration[:presence_address] || @@DEFAULT_PRESENCE_NETWORK      
      @presence_period = configuration[:presence_period] || @@DEFAULT_PRESENCE_PERIOD
      @presence_listener = EventListener.new self
      @presence_broadcaster = EventBroadcaster.new self
      
      @peer_registry = PeerRegistry.new self
    end
    
    def start
      # Start a peer listener first so we don't risk missing a connection attempt.
      putsd "Starting #{@peer_listener.class.to_s}"
      @peer_listener.start
      
      # Start listening for presence events.
      putsd "Starting #{@presence_listener.class.to_s}"
      @presence_listener.start
      
      # Start sending our own presence events!
      putsd "Starting #{@presence_broadcaster.class.to_s}"
      @presence_broadcaster.start
    end
    
    def stop
      # Stop broadcasting presence.
      @presence_broadcaster.stop
      # Stop listening for presence events, which prevents new peer registrations
      @presence_listener.stop
      # Stop listening for incoming peer data.
      @peer_listener.stop
      # Forcefull terminate all connections, which may be actively passing data.
      @peer_registry.unregister_all
    end
    
    def send_to_known_peers(payload)
      # Delegate directly.
      peer_registry.send_to_known_peers(payload)
    end
    
    def send_to_peer(peer_uuid, payload)
      # Delegate directly.
      peer_registry.send_to_peer(peer_uuid, payload)
    end
    
    # Returns metadata on all known peers in a hash, keyed by the uuid of each.
    # A record corresponding to this peer is not included.
    def known_peers(all_groups = false)
      peer_registry.all(all_groups)
    end
    
    # Adds (or updates) the given +PeerConnection+.
    def register_peer(peer)
      peer_registry.register(peer)
    end
    
    def unregister_peer(peer)
      peer_registry.unregister(peer)
    end
    
  end
  
end