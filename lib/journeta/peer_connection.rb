# Copyright 2007, OpenRain, LLC. All rights reserved.

module Journeta
  
  # An outgoing message tube. Messages may or may not arrive at the destination, but if they do they'll be in order.
  class PeerConnection < Journeta::Asynchronous
    
    include Logger
    
    attr_accessor :uuid
    attr_accessor :ip_address
    attr_accessor :peer_port
    attr_accessor :version
    attr_accessor :created_at
    attr_accessor :updated_at
    attr_accessor :groups
    
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
    
    def update_settings(other)
      @settings_lock.synchronize do
        self.ip_address = other.ip_address
        self.peer_port = other.peer_port
        self.version = other.version
        self.created_at = other.created_at
        self.updated_at = other.updated_at
      end
    end
    
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
        putsd "Peer #{uuid} has gone away. Deregistering self."
        # Yeah... kindof wierd, I know.
        Thread.new {
          @engine.unregister_peer(self)
        }
      end
    end
    
  end
  
end
