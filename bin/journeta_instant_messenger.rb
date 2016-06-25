#!/usr/bin/env ruby

banner =<<EOL
An IRC-like, serverless instant messenger for local area networks.
Fire up one or more of these on your local network-connected machine.
Copyright 2011-2016, Preston Lee. http://prestonlee.com

	Usage: #{$0}

EOL

puts banner


current_dir = File.dirname(File.expand_path(__FILE__))
lib_path = File.join(current_dir, '..', 'lib')
$LOAD_PATH.unshift lib_path

# Load up the library!
require 'journeta'
include Journeta
include Journeta::Common

# A message handler will be called by the engine every time a message is received.
# This code will be customized for your application-specific needs.
class ExampleHandler < Journeta::DefaultPeerHandler
  def call(message)
    if message.class == BasicMessage
      puts "#{message.name.chop}: #{message.text}"
    else
      putsd("Unsupported message type received from peer. (#{message})")
    end
  end
end

# Now we'll create an instance of the Journeta P2P engine.
#
# :peer_port -- We'll change the default incoming session port to a
# pseudo-randomly generated number so multiple instances
# may be started on the same machine.
#
# You'll need to find an unused port if..
# (1) you intend to run multiple peers on the same machine, or
# (2) the default port (Journeta::Engine::DEFAULT_PEER_PORT)
#     is otherwise already taken on your machine.
#
# :peer_handler -- A piece of logic you must specify to process objects sent to you from peers.
# :groups -- Defines the peer types which care about the objects you broadcast. (Optional: by default, all peers will receive all your object broadcasts.)
peer_port = (2048 + rand( 2 ** 8))
journeta = Journeta::Engine.new(:peer_port => peer_port, :peer_handler => ExampleHandler.new, :groups => ['im_example'])


# Let the magic begin!
journeta.start


# You can use the following helper to automatically stop the given engine when the application is killed with CTRL-C.
include Journeta::Common::Shutdown
stop_on_shutdown(journeta)

# Alternatively, you can stop the engine manually by calling +Engine#stop+.
# Do this before exiting to broadcast a message stating you are going offline as a courtesy to your peers, like so..
# @journeta.stop


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
    begin
      input = gets
      m = BasicMessage.new
      m.name = name
      m.text = input
      journeta.send_to_known_peers(m)
    end
  end
end



# The engine can be restarted and stopped as many times as you'd like.
#journeta.start
#journeta.stop
