#!/usr/bin/env ruby
current_dir = File.dirname(File.expand_path(__FILE__))
lib_path = File.join(current_dir, '..', 'lib')
$LOAD_PATH.unshift lib_path

require 'journeta'
include Journeta
include Journeta::Common
include Journeta::Common::Shutdown

clear = %x{clear} # HACK

peer_port = (2048 + rand( 2 ** 8))
@journeta = Journeta::Engine.new(:peer_port => peer_port)
@journeta.start
stop_on_shutdown(@journeta)


begin
  all = @journeta.known_peers    
  puts clear
  puts __FILE__
  puts "Displays infromation on all known peers."
  puts "Updated: #{Time.now}"
  puts "\n"
  puts "UUID\t\tVersion\t\tIP Address\t\tPort\t\tDiscovered\t\tUpdated\t\tGroups\n"
  all.keys.sort.each do |uuid|
    puts "#{all[uuid].uuid}\t#{all[uuid].version}\t\t#{all[uuid].ip_address}\t\t#{all[uuid].peer_port}\t\t#{all[uuid].created_at || 'TODO'}\t\t#{all[uuid].updated_at || 'TODO'}\t[#{all[uuid].groups.join(',')}]"
  end
  sleep(0.2)
end     while true
