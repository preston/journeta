# Copyright © 2007 OpenRain, LLC. All rights reserved.
# Preston Lee <preston.lee@openrain.com>


module Journeta
  
  class JournetaEngine
    
    include Logger
    
    # Constantly listens for incoming peer sessions
    attr_accessor :session_listener
    # Application logic which processes session data.
    attr_accessor :session_handler
    # Continuously sends out "i'm here" presence messages to the local network
    attr_accessor :event_broadcaster
    # continuously listens for "i'm here" presence messages from other peers
    attr_accessor :event_listener
    # Authoritative peer availability database.
    attr_accessor :peer_registry
    # Instance-specific configuration which may be overriden at initialization time by the application
    attr_reader :configuration

    # The universally-unique ID of this instance.
    attr_reader :uuid
    
    @@DEFAULT_SESSION_PORT = 31338
    @@DEFAULT_EVENT_PORT = 31337
    @@DEFAULT_SESSION_HANDLER = DefaultSessionHandler.new
    
    # Addresses 224.0.0.0 through 239.255.255.255 are reserved for multicast messages.
    @@DEFAULT_EVENT_NETWORK = '224.220.221.222'
    @@DEFAULT_EVENT_PERIOD = 4
    
    
    def initialize(configuration ={})
      putsd "CON: #{configuration}"
      @configuration = Hash.new
      
      # A supposedly universally unique id for this instance. not technically gauranteed but close enough for now.
      # TODO make guaranteed to be unique.
      @configuration[:uuid] = configuration[:uuid] || rand(2 ** 31)
      # the tcp port to use for direct peer connections
      @configuration[:session_port] = configuration[:session_port] || @@DEFAULT_SESSION_PORT

      @session_handler = configuration[:session_handler] || @@DEFAULT_SESSION_HANDLER
      
      # The UDP port for event broadcast messages.
      @configuration[:event_port] = configuration[:event_port] || @@DEFAULT_EVENT_PORT

      # The UDP network address used for broadcast messages.
      @configuration[:event_address] = configuration[:event_address] || @@DEFAULT_EVENT_NETWORK

      # The delay, in seconds, between presence notification broadcasts.
      @configuration[:event_period] = configuration[:event_period] || @@DEFAULT_EVENT_PERIOD
      
      # Initialize sub-components.
      @session_listener = Journeta::SessionListener.new self
      @event_listener = EventListener.new self
      @event_broadcaster = EventBroadcaster.new self
      @peer_registry = PeerRegistry.new self
    end
    
    def start
      # start a session listener first so we don't risk missing a connection attempt
      putsd "Starting #{@session_listener.class.to_s}"
      @session_listener.start
      
      # start listening for peer events
      putsd "Starting #{@event_listener.class.to_s}"
      @event_listener.start
      
      # start sending our own events
      putsd "Starting #{@event_broadcaster.class.to_s}"
      @event_broadcaster.start
    end
    
    def stop
      # stop broadcasting events
      @event_broadcaster.stop
      # stop listener for events
      @event_listener.stop
      # stop listening for incoming peer sessions
      @session_listener.stop
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
    def known_peers()
      peer_registry.peers # FIXME Returns objects outside of synchronized context.
    end
    
    # Adds (or updates) the given +PeerConnection+.
    def register_peer(peer)
      peer_registry.add(peer)
    end
    
  end
  
end