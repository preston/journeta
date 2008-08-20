#require 'yaml'

require 'journeta/asynchronous'


module Journeta
   
   class EventBroadcaster < Journeta::Asynchronous
      
      attr_accessor :thread

     	def go #(engine)
           address = @engine.configuration[:event_address]
           port = @engine.configuration[:event_port]
           delay = @engine.configuration[:event_period]
           uuid = @engine.configuration[:uuid]
           session_port = @engine.configuration[:session_port]
           begin
              socket = UDPSocket.open
              socket.setsockopt(Socket::IPPROTO_IP, Socket::IP_TTL, [1].pack('i'))
              loop do
                 putsd "Sending presence event."
                 note = PresenceMessage.new uuid, session_port
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

