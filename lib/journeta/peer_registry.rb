require 'thread'

module Journeta
  
  # responsible for keeping in-memory metadata on known peers,
  # as well as peer tcp connections
  class PeerRegistry #<< Journeta::Asynchronous
    
    include Logger
    
    # {<:uuid> => PeerConnection}
    #    attr_reader :peers
    
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
    
    def all(all_groups = false)
      r = nil
      @mutex.synchronize do
        r = all_do(all_groups)
      end
      return r
    end
    
    # Adds a +PeerConnection+ to the registry. It is optional but not necessary to call +PeerConnection#start+ before manually adding it to the registry!
    # If a peer with the same UUID is already registered, the given peer will be stopped and the existing one updated.
    def register(peer)
      raise "Do not try to register a nil peer!" if peer.nil?
      raise "You can only add #{PeerConnection} instances to this registry, not #{peer.class}!" unless peer.class == PeerConnection
      @mutex.synchronize do
        #        pp @peers
        existing = @peers[peer.uuid]
        if existing.nil?
          putsd "Adding peer #{peer.uuid}."
          peer.start
          @peers[peer.uuid] = peer
        else
          putsd "Updating peer #{peer.uuid}."
          peer.stop
          existing.update_settings peer
        end
        
      end
    end
    
    # Removes a +PeerConnection+ from the registry. If the peer is still broadcasting presence, it will magically become reregistered at some point!
    def unregister(peer)
      return unless !peer.nil? and peer.class == PeerConnection
      @mutex.synchronize do 
        peer.stop
        if peer.uuid
          @peers.delete peer.uuid
        end
      end
    end
    
    def send_to_known_peers(payload)
      # Iterate over each currently known peer and stuff the payload into each peers outgoing data queue.
      @mutex.synchronize do
        # Grab all peers in relevant groups.
        group = all_do
        n= group.length
        if n > 0
          putsd "Sending payload to #{n} peers."
          group.each do |uuid, conn|
            conn.send_payload payload
          end
        else
          putsd 'No peers (in relevant groups) to send message to!'
        end
      end
    end
    
    # Destroys all active connections.
    def unregister_all
      @mutex.synchronize do
        @peers.each do |uuid, n|
          n.stop
        end
      end
    end
    
    def send_to_peer(uuid, payload)
      @mutex.synchronize do
        p = @peers[uuid]
        if p
          p.send_payload(payload)
        end
      end
    end
    
    protected
    
    def all_do(all_groups = false)
      res = nil
      if all_groups
        # Create a new structure to avoid corruption of the original.
        res = Hash.new.update @peers
      else
        res = Hash.new
        @peers.each do |uuid, n|
          n.groups.each do |g|
            if @engine.groups.include?(g)
              res[uuid] = n
            end  
          end
        end
      end     
      return res
    end
    
    
  end
  
end