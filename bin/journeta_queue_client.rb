#!/usr/bin/env ruby
current_dir = File.dirname(File.expand_path(__FILE__))
lib_path = File.join(current_dir, '..', 'lib')
$LOAD_PATH.unshift lib_path

require 'journeta'
include Journeta
include Journeta::Common
include Journeta::Common::Shutdown

class JobProcessor
  def call(msg)
    if msg.class == Job && !msg.submission
      puts "Processing job ##{msg.name} from peer ##{msg.owner}."
    end
  end
end

peer_port = (2048 + rand( 2 ** 8))
journeta = Journeta::Engine.new(:peer_port => peer_port, :peer_handler => JobProcessor.new, :groups => ['queue_example'])
stop_on_shutdown(journeta)
journeta.start


# Keep creating random jobs.
puts "Don't forget to start a server at some point! CTRL-C to exit this client."
while true
  num = rand(1024)
  puts "Creating random job ##{num}."
  job = Job.new
  job.owner = journeta.uuid
  job.name = num
  job.description = 'whatever'
  job.data = 'Anything YAML serializable!'
  job.submission = true
  journeta.send_to_known_peers(job) # All servers will get it.
  sleep 4
end
