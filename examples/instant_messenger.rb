#!/usr/bin/env ruby
current_dir = File.dirname(File.expand_path(__FILE__))
lib_path = File.join(current_dir, '..', 'lib')
$LOAD_PATH.unshift lib_path

require 'journeta'

include Journeta

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
# You'll need to find an unused port if..
# (1) you intend to run multiple peers on the same machine, or
# (2) the default port (Journeta::JournetaEngine::DEFAULT_SESSION_PORT)
#     is otherwise already taken on your machine.
session_port = (2048 + rand( 2 ** 8))

# Any arbitrary object can be sent to peers as long as it's serializable to YAML.
class ExampleMessage
  attr_accessor :text
end
    
class ExampleHandler < Journeta::DefaultSessionHandler
  def handle(message)
    puts message.text
  end
end


# No we'll create an instance of the Journeta P2P engine and pass in our options
journeta = Journeta::JournetaEngine.new(:session_port => session_port, :messege_handler => handler, :session_handler => ExampleHandler.new)

# Let the magic begin
journeta.start

# Sit around are watch events at the console until the user hits <enter>
begin
   loop do
      input = gets
      m = ExampleMessage.new
      m.text = input
      journeta.send_to_known_peers(m)
   end
ensure
end

# Remember to stop the engine when shutting down. This broadcasts a message
# stating you are going offline as a courtesy to your peers.
journeta.stop

# The engine can be restarted and stopped as many times as you'd like.
journeta.start
journeta.stop