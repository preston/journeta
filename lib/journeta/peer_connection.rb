module Journeta
  
  # An outgoing message tube. Messages may or may not arrive at the destination, but if they do they'll be in order.
  class PeerConnection
    
    include Logger
    
    attr_accessor :uuid
    attr_accessor :ip_address
    attr_accessor :session_port
    attr_accessor :version
    attr_accessor :created_at
    attr_accessor :updated_at
    
    # Returns whether or not the payload was sent successfully.
    def send_payload(payload)
      raise "Don't try to send nil payloads!" if payload.nil?
      ok = true
      begin
        s = TCPSocket.new(ip_address, session_port)
        data = YAML::dump(payload)
#        pp data
        s.send(data , 0)
        s.close
      rescue
        putsd "Peer #{uuid} has gone away."
        ok = false
      end
      return ok
    end
    
  end
  
end
