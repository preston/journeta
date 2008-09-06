#!/usr/bin/env ruby
current_dir = File.dirname(File.expand_path(__FILE__))
lib_path = File.join(current_dir, '..', 'lib')
$LOAD_PATH.unshift lib_path

puts 'Sends a whole bunch of naughty stuff to peers to attempt to induce crashiness.'

# Load up the library!
require 'journeta'
include Journeta
include Journeta::Common

require 'pp'

# We'll join all group to invoke the maximum amount of nastiness.
# :groups => nil
@journeta = JournetaEngine.new

puts "Starting malicious peer..."
@journeta.start

puts "Finding peers..."
sleep JournetaEngine::DEFAULT_PRESENCE_PERIOD + 2

puts "Known groups.."
pp @journeta.known_groups

def fuzz(data)
  @journeta.send_to_known_peers(data)
end

class Journeta::Crap
  attr_accessor :wtf
end

puts "Sending a whole bunch of bogus crap to all peers. MuahahahahHAHAHA!!!"
# fuzz(nil) # Client won't allow this :)
fuzz('wierd string!')
fuzz(Journeta::Crap.new)
#fuzz(Journeta::Crap)
fuzz(42)
fuzz(42.42)

puts "Shutting down the peer..."
@journeta.stop

puts "Exiting."
