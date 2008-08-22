#!/usr/bin/env ruby
current_dir = File.dirname(File.expand_path(__FILE__))
lib_path = File.join(current_dir, '..', 'lib')
$LOAD_PATH.unshift lib_path

require 'journeta'
include Journeta


COUNT = 5
puts "Creating #{COUNT} mock peers."
instances = []
for i in 1..COUNT
  n = JournetaEngine.new(:peer_port => (12345 + i))
  instances.push n
  n.start
end


puts "Hit <ENTER> to stop all #{COUNT} peer instances exit."
gets
instances.each do |i|
  i.stop
end

puts "All instances stopped. Exiting..."
