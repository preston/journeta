#!/usr/bin/env ruby
current_dir = File.dirname(File.expand_path(__FILE__))
lib_path = File.join(current_dir, '..', 'lib')
$LOAD_PATH.unshift lib_path

require 'journeta'
include Journeta
include Journeta::Common
include Journeta::Common::Shutdown

require 'rubygems'
begin
  require 'curses'
rescue
  puts 'Please install the curses gem to use this example.'
  exit 1
end

peer_port = (2048 + rand( 2 ** 8))
@journeta = Journeta::JournetaEngine.new(:peer_port => peer_port)
@journeta.start
stop_on_shutdown(@journeta)

Curses.init_screen
Curses.setpos(0,0)
Curses::addstr("Press ^C to quit.\n")

@run = true
@run_lock = Mutex.new

refresh = Thread.new do
  keep_going = true
  begin
    @run_lock.synchronize do
      keep_going = @run
    end
    all = @journeta.known_peers
    
    Curses.clear
    Curses.setpos(0,0)
    Curses.addstr "UUID\tVersion\tIP Address\tGroups\tDiscovered\tUpdated\n"
    all.keys.sort.each do |uuid|
      Curses.addstr "#{all[uuid].uuid}\t#{all[uuid].version}\t#{all[uuid].ip_address}\t#{all[uuid].groups}\t#{all[uuid].created_at}\t#{all[uuid].updated_at}\t"
    end
    sleep(0.1)
  end     while keep_going
end

begin
  c = nil
  begin
    c = Curses.getch
  end until c == ?C or c == ?\e
  Curses.setpos(0,0)
  Curses.clear
  Curses.setpos(0,0)
end until c == ?\e

@run_lock.synchronize do
  @run = false
end
