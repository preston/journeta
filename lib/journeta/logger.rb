# Copyright 2011, Preston Lee Ventures, LLC. All rights reserved.


module Journeta
   
   # A silly logging implementation intended for internal use only. Nothing to see here!
   module Logger
      
      # A thread safe method for printing the given string if and only if debugging is enabled.
      def putsd(message = '(no message)')
         $stderr.print("DEBUG: #{message}\n") if $DEBUG
      end

	end
	
end