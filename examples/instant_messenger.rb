#!/usr/bin/env ruby
current_dir = File.dirname(File.expand_path(__FILE__))
lib_path = File.join(current_dir, '..', 'lib')
$LOAD_PATH.unshift lib_path

# Load up the library!
require 'journeta'
include Journeta


# Any arbitrary object can be sent to peers as long as it's serializable to YAML.
# We'll create an ordinary class with a couple typical-looking fields to send to our peers.
class ExampleMessage
  attr_accessor :name
  attr_accessor :text
end

# A message handler will be called by the engine every time a message is received.
# This code will be customized for your application-specific needs.
class ExampleHandler < Journeta::DefaultSessionHandler
  def handle(message)
    puts "#{message.name.chop}: #{message.text}"
  end
end

# Now we'll create an instance of the Journeta P2P engine.
# We'll change the default incoming session port to a
# pseudo-randomly generated number so multiple instances
# may be started on the same machine.
#
# You'll need to find an unused port if..
# (1) you intend to run multiple peers on the same machine, or
# (2) the default port (Journeta::JournetaEngine::DEFAULT_SESSION_PORT)
#     is otherwise already taken on your machine.
session_port = (2048 + rand( 2 ** 8))
journeta = Journeta::JournetaEngine.new(:session_port => session_port, :session_handler => ExampleHandler.new)


# Let the magic begin!
journeta.start

puts "What's your name?"
name = gets

# The `known_peers` call allows you to access the registry of known available peers on the network.
# The UUID associated which each peer will be unique accross the network.
peers = journeta.known_peers
if peers.size > 0
  puts 'The following peers IDs are online..'
  peers.each do |uuid, peer|
    puts " #{uuid}; version #{peer.version}"
  end
else
  puts 'No peers known. (Start another client!)'
end


# Sit around are watch events at the console until the user hits <enter>
puts 'Text you enter here will automatically be shown on peers terminals.'
begin
   loop do
      input = gets
      m = ExampleMessage.new
      m.name = name
      m.text = input
      journeta.send_to_known_peers(m)
   end
ensure
end

# Please stop the engine when shutting down. This broadcasts a message
# stating you are going offline as a courtesy to your peers.
journeta.stop

# The engine can be restarted and stopped as many times as you'd like.
journeta.start
journeta.stop