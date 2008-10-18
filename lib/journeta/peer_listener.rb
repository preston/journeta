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
            # We'll put the actual handling of the new session in the background so we 
            # can continue listening for new connections as soon as possible.
            Thread.new(socket) do |socket| 
              session = socket.accept
              data = ''
              # Read every last bit from the socket before passing off to the handler.
              while more = session.gets
                data += more
              end
              begin
                msg     = YAML::load(data)
                h = @engine.peer_handler
                h.call msg              
              rescue
                putsd "YAML could not be deserialized! The data will not be passed up to the application."
              end
            end
          end
        rescue
          putsd "Session closed."
        end 
      ensure 
        putsd "Closing peer listener socket."
        # session.close
        # socket.close
      end
    end
    
  end
  
end