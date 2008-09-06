#!/usr/bin/env ruby
current_dir = File.dirname(File.expand_path(__FILE__))
lib_path = File.join(current_dir, '..', 'lib')
$LOAD_PATH.unshift lib_path

require 'journeta'
include Journeta

#puts "Threads before start: #{Thread.count}"

j = Engine.new
j.start
sleep 10
j.stop

#puts "Threads after stop: #{Thread.count}"
