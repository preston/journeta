$:.unshift "../lib"

require 'journeta'


# We start by defining a message handler to print messages received
# from peers to the console. This code will be customized for your
# application-specific needs.
class SampleMessageHandler
   def handle(message, from)
      putsd "#{from} say's: #{message}"
   end
end

handler = SampleMessageHandler.new

# We'll all change the default incoming session port to a
# pseudo-randomly generated number so multiple instances
# may be started on the same machine.
#
# Your application probably won't need to do this unless..
# (1) you intend to run multiple peers on the same machine, or
# (2) the default port (Journeta::JournetaEngine::DEFAULT_SESSION_PORT)
#     is already taken on your machine.
session_port = (2048 + rand( 2 ** 8))


# No we'll create an instance of the Journeta P2P engine and pass in our options
journeta = Journeta::JournetaEngine.new(:session_port => session_port, :messege_handler => handler)

# Let the magic begin
journeta.start

# Sit around are watch events at the console until the user hits <enter>
input = gets
# begin
#    loop do
#       input = gets
#    end
# ensure
# end

# Remember to stop the engine when shutting down. This broadcasts a message
# stating you are going offline as a courtesy to your peers.
journeta.stop

# The engine can be restarted and stopped as many times as you'd like.
# journeta.start
# journeta.stop