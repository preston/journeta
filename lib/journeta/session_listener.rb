require 'socket'

module Journeta
   
   class SessionListener < Journeta::Asynchronous
   
      def go #(engine)
         begin
            port = engine.configuration[:session_port]
            socket = TCPServer.new(port) 
            putsd "Listening on port #{port}"
            session = socket.accept

            begin
               loop do 
                  msg      = session.gets 
                  putsd "New Session: #{msg}"
                  # session.print 'w00t!'
               end
            rescue
               putsd "Session closed."
            end 
         ensure 
            putsd "Closing event listener socket."
             # session.close
             # socket.close
         end
      end
   
   end

end