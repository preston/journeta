#!/usr/bin/env ruby
current_dir = File.dirname(File.expand_path(__FILE__))
lib_path = File.join(current_dir, '..', 'lib')
$LOAD_PATH.unshift lib_path

require 'journeta'
include Journeta

def thread_count
	Thread.list.inject(0) {|i,n| n.status == 'run' ? (i+1) : i}.to_s
end

puts 'Threads before start: ' + thread_count

j = Engine.new
j.start
sleep 1 # Let it run very briefly.
j.stop
puts 'Threads after stop: ' + thread_count
