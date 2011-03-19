#!/usr/bin/env ruby

puts <<EOF

Slides for the Journeta P2P lightning talk given Friday, March 18th, 2011
at MountainWest RubyConf in Salt Lake City, Utah, USA.

 	Author: Preston Lee
 	http://prestonlee.com
 	https://github.com/preston/journeta

EOF



[
	'rvm use (1.9.2 || jruby)',
'gem install journeta',
'get on the "XMission" wifi network"',
'run "journeta_network_status.rb" in another tab',
"warning: it's a public network don't sue me k!",
"let's write a distributed 'irc'-like client ('journeta_instant_messenger.rb')",

].each_with_index do |l,i| puts "#{i}: #{l}" end