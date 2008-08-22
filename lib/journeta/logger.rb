# Copyright 2007, OpenRain, LLC. All rights reserved.


module Journeta
   
   module Logger
      
      # a thread safe method for printing the given string if and only if debugging is enabled
      def putsd(message = '(no message)')
         $stderr.print("DEBUG: #{message}\n") if $DEBUG
      end

	end
	
end