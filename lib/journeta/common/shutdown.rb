module Journeta
  
  module Common
    
    module Shutdown
      
      def stop_on_shutdown(engine)
        bye = Proc.new {
          engine.stop
          exit 0
        }
        Signal::trap("HUP", bye)
        Signal::trap("INT", bye)
        Signal::trap("KILL", bye)
      end
      
    end
    
  end
  
end