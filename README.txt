= Journeta

== About


Journeta is a dirt simple peer discovery and message passing library for processes on the same LAN,
requiring no advanced networking knowledge to use.

Only core Ruby libraries are required, making the library fairly light. As all data is sent accross
the wire in YAML form, any arbitrary Ruby object can be sent to peers, provided they..

 * Are running a compatible Journeta version.
 * Have access to the same class definitions if you are sending your own custom objects.
 * Do not have a firewall preventing network I/O.

Journeta uses Ruby threading to manage the asynchonous nature of peer-to-peer I/O.
Data you send from your application thread will be queued and sent asynrchonously as soon as possible. 
For insight into events internal to the library, start ruby with the `--debug` options.


== Use


 examples/instant_messenger.rb
 
    A completely distributed, zero-configuration-required chat room script.
    Fire up several instances in separate terminals. Multiple instances on the same machine is ok.
    Everything you type will automatically be sent to all other instances on the LAN!
    Use `ruby --debug examples/instant_messenger.rb` for detailed internal event details.

 examples/instant_messenger_gui.rb

	A GUI version of the above client. Require the wxruby gem. (`sudo gem install wxruby`)

 examples/queue_server.rb
 examples/queue_client.rb

	A simple queue managed by a server. Each client produces jobs to be queued, and processes jobs
	sent from the server(s). All nodes automatically find eachother. Try running multiples clients,
	and then multiple servers. Notice that when you have N servers, each job gets run N times,
	and not necessarilly by the same client!
	
== Author

Preston Lee <preston.lee at openrain d0t com>
http://www.prestonlee.com
http://www.openrain.com


== Links

How Journeta discovers peers using UDP multicasting..
http://onestepback.org/index.cgi/Tech/Ruby/MulticastingInRuby.red
