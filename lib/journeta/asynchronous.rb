# Copyright © 2007 OpenRain, LLC. All rights reserved.
#
# Preston Lee <preston.lee@openrain.com>


require 'journeta/logger'


module Journeta
  
  # See Journeta::Engine
  class Asynchronous
    
    include Logger
    
    attr_accessor :thread, :engine
    
    
    
    def initialize(engine)
      @engine = engine
      @thread_lock = Mutex.new
      @thread = nil
    end
    
    
    
    # Start the +Thread+ for this instance, iff not already running.
    def start
      @thread_lock.synchronize do
        if @thread
          # Do not restart it.
        else
          putsd "Creating asynchronous thread for I/O: #{self.class.to_s}."
          @thread = Thread.new {
            go
          }
        end
      end
    end
    
    # This method is intentionally not present because it would be of no real value. By the time a boolean is returned, the instance could be in a totally different state.
    #    def started  
    #      stopped = true
    #      @thread_lock.synchronize do
    #        stopped = @thread.nil?
    #      end
    #      return stopped
    #    end
    
    # Stop the +Thread+ associated with this instance, iff not already stopped.
    def stop
      @thread_lock.synchronize do
        if @thread
          Thread.kill(@thread)
          @thread.join
          @thread = nil
        end
      end
    end
    
    # Abstract thread logic method which must be implemented by the sub-class.
    def go
      raise NotImplementedException
    end
    
  end
  
end
