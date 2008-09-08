# Copyright © 2007 OpenRain, LLC. All rights reserved.
#
# Preston Lee <preston.lee@openrain.com>
module Journeta
  
  # An outgoing message tube. Messages may or may not arrive at the destination, but if they do they'll be in order.
  class PeerConnection < Journeta::Asynchronous

    include Logger
    
    # String
    attr_accessor :uuid
    attr_accessor :ip_address
    attr_accessor :version
    
    # An Array of Strings.
    attr_accessor :groups
    
    # Time.
    attr_accessor :created_at
    attr_accessor :updated_at
    
    # integer.
    attr_accessor :peer_port


    def initialize(engine)
      super(engine)
      @queue = Queue.new
      @settings_lock = Mutex.new      
    end
    
    # Adds the given payload to the outbound message queue and immediately returns.
    def send_payload(payload)
      raise "Don't try to send nil payloads!" if payload.nil?
      @queue.push payload
    end
    
    # Updates this instances settings by copying from a provided template.
    # Peers can, in theory, change IP address, port, version and group
    # settings without re-registering in this instance,
    # which would drop all pending outbound data from this connection queue,
    # and the creation and registration of a new connection record.
    # Peer metadata of this instance will be updated from the same fields of the given instance,
    # however, the internal queue of this instance and current thread I/O context will remain unchanged.
    def update_settings(other)
      @settings_lock.synchronize do
        self.ip_address = other.ip_address if other.ip_address
        self.peer_port = other.peer_port if other.peer_port
        self.version = other.version if other.version
        self.created_at = other.created_at if other.created_at
        self.updated_at = other.updated_at if other.updated_at
      end
    end
    
    # Implementation of abstract parent declaration.
    def go
      begin
        while true
          # TODO Reuse TCP connections between pops!
          payload = @queue.pop
          s = nil
          @settings_lock.synchronize do # To prevent corruption of settings.
            s = TCPSocket.new(ip_address, peer_port)       
          end
          data = YAML::dump(payload)
          #        pp data
          s.send(data , 0)
          s.close
        end
      rescue
        # Ok, so this is kindof wierd.
        # Unregistering ourselves in our own thread is a paradox becasue
        # we'd end up killing ourselves before the call completes and the unregistration process can finish.
        # The end effect being we could end up with a stopped peer connection which is still registered.
        # So to kill ourselves cleanly, we need to create *another* thread exclusively for the task.
        # If somehow we end up in this block again before our child thread kills us, we're ok to create another one
        # because the registry will just ignore a request to unregister an unknown connection, and it's internally
        # protected against registry corruption with an exclusive lock.
        #
        # Sorry that this is deceptively complicated. It's a design gotcha! :)
        putsd "Peer #{uuid} has gone away. Deregistering in the background."
        Thread.new {
          @engine.unregister_peer(self)
        }
      end
    end
    
  end
  
end
