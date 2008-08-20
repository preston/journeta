require 'yaml'
require 'socket'
require 'ipaddr'
require 'journeta/asynchronous'

module Journeta

   # uses the fucked up socket api to listen for events broadcast from peers
   class EventListener < Journeta::Asynchronous

      
   	def go #(engine)
   	   event_address = @engine.configuration[:event_address]
   	   port = @engine.configuration[:event_port]
   	   addresses =  IPAddr.new(event_address).hton + IPAddr.new("0.0.0.0").hton
   	   begin
      	   socket = UDPSocket.new
      	   # remember how i said this was fucked up? yeaahhhhhh. i hope you like C.
      	   # `man setsockopt` for details.
      	   # SO_REUSEPORT is needed so multiple peers can be run on the same machine.
            socket.setsockopt( Socket::SOL_SOCKET, Socket::SO_REUSEPORT, [1].pack("i_") )
            # socket.setsockopt( Socket::SOL_SOCKET, Socket::SO_REUSEADDR, [1].pack("i_") )
            socket.setsockopt(Socket::IPPROTO_IP, Socket::IP_ADD_MEMBERSHIP, addresses)
            socket.bind(Socket::INADDR_ANY, port)
            putsd "Waiting for presence events."
            loop do
               # why 1024? umm.. because it's thursday?
               data, meta = socket.recvfrom 1024
               Thread.new(data) {
                  event = YAML.load(data)
                  if event.uuid != @engine.configuration[:uuid]
                     putsd "New Event: #{data} #{meta.inspect}"
                     # update registry
                     # peer = PeerConnection
                     # @engine.update
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