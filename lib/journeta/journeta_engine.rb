# Copyright © 2007 OpenRain, LLC. All rights reserved.
#
# Preston Lee <preston.lee@openrain.com>

# The root namespace for the entire #Journeta library.
# See..
#  * Journeta::Engine
#  * http://journeta.rubyforge.org
module Journeta
  
  # The primary fascade of the entire +Journeta+ library, which composite a number of
  # objects running asynchronously to the primary application +Thread+. Use of this fascade
  # requires a minimal amount of lifecycle management on your part to start and stop the
  # engine at appropriate times. (Usually only at application startup and shutdown, respectively.)
  class Engine
    
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
    DEFAULT_PEER_PORT = 31338
    
    # On UDP port on which we send/receive peer presence messages.
    DEFAULT_PRESENCE_PORT = 31337
    
    # Addresses 224.0.0.0 through 239.255.255.255 are reserved for multicast messages.
    DEFAULT_PRESENCE_NETWORK = '224.220.221.222'
    
    # The wait time, in seconds, between rebroadcasts of peer presence.
    DEFAULT_PRESENCE_PERIOD = 4
    
    
    # Nothing magical. Just creation of internal components and configuration setup.
    def initialize(configuration ={})      
      # TODO make guaranteed to be unique.
      @uuid = configuration[:uuid] || rand(2 ** 31)
      @groups = configuration[:groups]

      
      @peer_port = configuration[:peer_port] || DEFAULT_PEER_PORT
      @peer_handler = configuration[:peer_handler] || DefaultPeerHandler.new

      @presence_port = configuration[:presence_port] || DEFAULT_PRESENCE_PORT    
      @presence_address = configuration[:presence_address] || DEFAULT_PRESENCE_NETWORK      
      @presence_period = configuration[:presence_period] || DEFAULT_PRESENCE_PERIOD
      
      # Inversion of Control is used in the following components to allow for some semblance of testing.
      @peer_listener = configuration[:peer_listener] || Journeta::PeerListener.new(self)
      @peer_registry = configuration[:peer_registry] || PeerRegistry.new(self)
      @presence_listener = configuration[:presence_listener] || PresenceListener.new(self)
      @presence_broadcaster = configuration[:presence_broadcaster] || PresenceBroadcaster.new(self)
    end
    
    
    # Starts sub-comonents which have their own life-cycle requirements.
    # The registry itself does not have a dedication thread, and thus does not need to be started.
    def start
      # Start a peer listener first so we don't risk missing a connection attempt.
      putsd "Starting #{@peer_listener.class.to_s}"
      @peer_listener.start
      
      # Start listening for peer presence announcements next.
      putsd "Starting #{@presence_listener.class.to_s}"
      @presence_listener.start
      
      # Now that we're all set up, start sending our own presence events
      # so peer can start sending us data!
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
      
      # While the registry does not have its own thread, it is in charge of managing
      # +PeerConnection+s which DO have individual threads. This call
      # forcefully terminates all connections, which may or may not be actively passing data.
      @peer_registry.unregister_all
    end
    
    # Sends the given object to all peers in one of the #groups associated with this instance.
    # The object will be marshalled via YAML, so anything the YAML serializer misses won't make it to the other side(s). 
    # The return value is undefined.
    def send_to_known_peers(payload)
      # Delegate directly.
      peer_registry.send_to_known_peers(payload)
    end
    
    # Send the given object to the peer of the given UUID, if available.
    # The return value is undefined.
    def send_to_peer(peer_uuid, payload)
      # Delegate directly.
      peer_registry.send_to_peer(peer_uuid, payload)
    end
    
    # Returns metadata on all known peers in a hash, keyed by the uuid of each.
    # A record corresponding to this peer is not included.
    def known_peers(all_groups = false)
      peer_registry.all(all_groups)
    end
    
    def known_groups()
      s = Set.new
      self.known_peers(true).each do |uuid, peer|
        s.merge peer.groups
      end
      s.to_a
    end
    
    # Adds (or updates) the given +PeerConnection+. If a peer of the same UUID is found,
    # the existing record will be updated and given instance #PeerConnection#stop'd.
    # This prevents pending outbound data from being accidentally dropped.
    def register_peer(peer)
      peer_registry.register(peer)
    end
    
    # Forcefully unregisters the given #PeerConnection, though this is of limited use
    # since the #PresenceListener will eventually automatically re-register
    # the peers UUID if it's still online.
    def unregister_peer(peer)
      peer_registry.unregister(peer)
    end
    
  end
  
end