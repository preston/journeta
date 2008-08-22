require 'yaml'
require 'socket'
require 'ipaddr'
require 'journeta/asynchronous'
require 'journeta/peer_connection'

module Journeta
  
  # uses the fucked up socket api to listen for events broadcast from peers
  class EventListener < Journeta::Asynchronous
    
    
    def go
      presence_address = @engine.presence_address
      port = @engine.presence_port
      addresses =  IPAddr.new(presence_address).hton + IPAddr.new("0.0.0.0").hton
      begin
        socket = UDPSocket.new
        # Remember how i said this was fucked up? yeaahhhhhh. i hope you like C.
        # `man setsockopt` for details.
        # SO_REUSEPORT is needed so multiple peers can be run on the same machine.
        socket.setsockopt( Socket::SOL_SOCKET, Socket::SO_REUSEPORT, [1].pack("i_") )
        # socket.setsockopt( Socket::SOL_SOCKET, Socket::SO_REUSEADDR, [1].pack("i_") )
        socket.setsockopt(Socket::IPPROTO_IP, Socket::IP_ADD_MEMBERSHIP, addresses)
        socket.bind(Socket::INADDR_ANY, port)
        putsd "Waiting for presence events."
        loop do
          # Why 1024? umm.. because it's Thursday!
          data, meta = socket.recvfrom 1024
          Thread.new(data) {
            event = YAML.load(data)
            if event.uuid != @engine.uuid
              m = YAML::load(data)
              peer = PeerConnection.new @engine
              # Why is this always [2]? Not sure.. they should have returned a hash instead.
              peer.ip_address = meta[2]
              peer.peer_port = m.peer_port
              peer.uuid = m.uuid
              peer.version = m.version
              peer.groups = m.groups
              # TODO validate peer entry is sane before registering it
#              peer.start
              @engine.register_peer peer
            end
          }
          # putsd "Event received!"
        end
      ensure
        putsd "Closing event listener socket."
        socket.close
      end
    end
    
  end
  
end