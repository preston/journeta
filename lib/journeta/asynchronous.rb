require 'journeta/logger'

module Journeta

   class Asynchronous
      
      include Logger
      
      attr_accessor :thread, :engine

      def initialize(engine)
         @engine = engine
      end
      
      def start
         putsd "Creating asynchronous thread for I/O: #{self.class.to_s}."
         @thread = Thread.new {
            go # @engine
         }
      end
      	      
      def stop
         Thread.kill(@thread)
         @thread.join
         @thread = nil
   	end
   	
   	def go #(engine)
   	   raise NotImplementedException
	   end
	   
	end
	
end
