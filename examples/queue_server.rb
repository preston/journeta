#!/usr/bin/env ruby
current_dir = File.dirname(File.expand_path(__FILE__))
lib_path = File.join(current_dir, '..', 'lib')
$LOAD_PATH.unshift lib_path

require 'thread'
require 'journeta'
include Journeta
include Journeta::Common
include Journeta::Common::Shutdown

@queue = Queue.new

class JobQueuer
  def initialize(queue)
    @queue = queue
  end
  def handle(msg)
    if msg.class == Job && msg.submission
      puts "Enqueing job '##{msg.name}' from peer ##{msg.owner}."
      msg.submission = false
      @queue.push msg
    end
  end
end

peer_port = (2048 + rand( 2 ** 8))
journeta = Journeta::JournetaEngine.new(:peer_port => peer_port, :peer_handler => JobQueuer.new(@queue), :groups => ['queue_example'])
stop_on_shutdown(journeta)
journeta.start


puts "CTRL-C to stop server."
total = 0
while true
  job = @queue.pop
  puts "Job found! (#{job.name})"
  all = journeta.known_peers.values
  # Note that this list might already be outdated by the time we reach the next line!
  
  if all.size > 0
    # Pick a random client
    worker = all[rand(all.size)]
    puts "Sending to peer ##{worker.uuid}."
    journeta.send_to_peer(worker.uuid, job)
  else
    puts "No workers found :(  Will check again soon!"
    @queue.push job
    sleep 4 # Wait for peers to join
  end
end
