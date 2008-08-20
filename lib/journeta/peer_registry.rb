require 'thread'

module Journeta
  
  # responsible for keeping in-memory metadata on known peers,
  # as well as peer tcp connections
  class PeerRegistry #<< Journeta::Asynchronous
    
    include Logger
    
    # {<:uuid> => PeerConnection}
    attr_reader :peers
    
    def initialize(engine)
      @engine = engine
      @peers = {}
      @mutex = Mutex.new
    end
    
    def clear
      @mutex.synchronize do
        h.clear
      end
    end
    
    def add(peer)
      raise "Do not try to register a nil peer!" if peer.nil?
      raise "You can only add #{PeerConnection} instances to this registry, not #{peer.class}!" unless peer.class == PeerConnection
      @mutex.synchronize do
        #        pp @peers
        existing = @peers[peer.uuid]
        if existing.nil?
          putsd "Adding peer #{peer.uuid}."
        else
          putsd "Updating peer #{peer.uuid}."
        end
        @peers[peer.uuid] = peer
      end
    end
    
    def send_to_known_peers(payload)
      # Iterate over each currently known peer and stuff the payload into each peers outgoing data queue.
      @mutex.synchronize do
        if peers.count > 0
          peers.each do |uuid, conn|
            sent = conn.send_payload payload
            if !sent
              # The peer probably went away, so unregister it.
              peers.delete uuid
            end
          end
        else
          putsd 'No peers known to send message to!'
        end
      end
    end
    
    def send_to_peer(uuid, payload)
      sent = peers[uuid].send_payload(payload)
      if !sent
        # The peer probably went away, so unregister it.
        @mutex.synchronize do
          peers.remove uuid
        end
      end
    end
    
  end
  
end