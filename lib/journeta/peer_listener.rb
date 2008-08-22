# Copyright © 2007 OpenRain, LLC. All rights reserved.
#
# Preston Lee <preston.lee@openrain.com>

require 'socket'

module Journeta
  
  # Accepts inbound connections from other peers using TCP.
  # After the peer finishes sending data, the connection is terminated.
  # No data is returned to the sender.
  class PeerListener < Journeta::Asynchronous
    
    def go
      begin
        # Grab configuration information from the injected object.
        port = @engine.peer_port
        socket = TCPServer.new(port) 
        putsd "Listening on port #{port}"
        
        begin
          loop do             
            session = socket.accept
            # We'll put the actual handling of the new session in the background so we 
            # can continue listening for new connections as soon as possible.
            Thread.new do 
              data = ''
              # Read every last bit from the socket before passing off to the handler.
              while more = session.gets
                data += more
              end
              msg     = YAML::load(data)
              h = @engine.peer_handler
              h.handle msg              
            end
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