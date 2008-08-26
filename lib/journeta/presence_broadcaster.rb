#require 'yaml'

require 'journeta/asynchronous'


module Journeta
  
  # Spams the local area network with metadata about the local instance.
  # This allows peers to make direct connections back at a later time.
  class PresenceBroadcaster < Journeta::Asynchronous
    
    attr_accessor :thread
    
    def go
      address = @engine.presence_address
      port = @engine.presence_port
      delay = @engine.presence_period
      uuid = @engine.uuid
      peer_port = @engine.peer_port
      groups = @engine.groups
      begin
        socket = UDPSocket.open
        begin
          if PLATFORM[/linux/i]
            socket.setsockopt( Socket::SOL_SOCKET, Socket::SO_REUSEADDR, [1].pack("i_") )
          else
            # socket.setsockopt(Socket::IPPROTO_IP, Socket::IP_TTL, [1].pack('i')) # Preston's original config for OS X.
            socket.setsockopt( Socket::SOL_SOCKET, Socket::SO_REUSEPORT, [1].pack("i_") ) # Remi's suggested default.
          end
        rescue
          puts "Native socket library not supported on this platform. Please submit a patch! Exiting since this is fatal :("
          exit 1
        end    
        loop do
          putsd "Sending presence event."
          note = PresenceMessage.new uuid, peer_port, groups
          socket.send(note.to_yaml, 0, address, port)
          sleep delay
        end
      ensure
        putsd "Closing event broadcaster socket."
        socket.close
      end
    end
    
  end
  
end
