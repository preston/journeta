# Copyright © 2007 OpenRain, LLC. All rights reserved.
# Preston Lee <preston.lee@openrain.com>

require 'journeta/event_broadcaster'
require 'journeta/event_listener'
require 'journeta/presence_message'
require 'journeta/session_listener'
require 'journeta/logger'

module Journeta
   
   class JournetaEngine
      
      include Logger
   
      # constantly listens for incoming peer sessions
      attr_accessor :session_listener
      # continuously sends out "i'm here" presence messages to the local network
      attr_accessor :event_broadcaster
      # continuously listens for "i'm here" presence messages from other peers
      attr_accessor :event_listener
      # instance-specific configuration which may be overriden at initialization time by the application
      attr_reader :configuration
   
      @@DEFAULT_SESSION_PORT = 31337
      @@DEFAULT_EVENT_PORT = 31337
      
      # addresses 224.0.0.0 through 239.255.255.255 are reserved for multicast messages
      @@DEFAULT_EVENT_NETWORK = '224.220.221.222'
      @@DEFAULT_EVENT_PERIOD = 4
   
   
      def initialize(configuration ={})
         putsd "CON: #{configuration}"
         @configuration = Hash.new
         
         # a supposedly universally unique id for this instance. not technically gauranteed but close enough for now.
         @configuration[:uuid] = configuration[:uuid] || rand(2 ** 31)
         # the tcp port to use for direct peer connections
         @configuration[:session_port] = configuration[:session_port] || @@DEFAULT_SESSION_PORT
         # the udp port for event broadcast messages
         @configuration[:event_port] = configuration[:event_port] || @@DEFAULT_EVENT_PORT
         # the udp network address used for broadcast messages
         @configuration[:event_address] = configuration[:event_address] || @@DEFAULT_EVENT_NETWORK
         # the delay, in seconds, between presence notification broadcasts
         @configuration[:event_period] = configuration[:event_period] || @@DEFAULT_EVENT_PERIOD
      
         # initialize sub-components
         @session_listener = Journeta::SessionListener.new self
         @event_listener = EventListener.new self
         @event_broadcaster = EventBroadcaster.new self
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
         # iterate over each currently known peer
         # stuff the payload into each peers outgoing data queue
      end
      
      def send_to_peer(peer_uuid, payload)
         # grab the peer model
         # if valid, stuff the payload into the peers outgoing data queue
      end
      
      # Returns metadata on all known peers in a hash, keyed by the uuid of each.
      # A record corresponding to this peer is not included.
      def known_peers()
         
      end
   
   end

end