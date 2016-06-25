# Journeta

## About


Journeta is a dirt simple peer discovery and message passing library for processes on the same LAN,
requiring no advanced networking knowledge to use.

Only core Ruby libraries are required, making the library fairly light. As all data is sent across the wire in YAML form, any arbitrary Ruby object can be sent to peers, provided they:

1. Are running a compatible Journeta version.
1. Have access to the same class definitions if you are sending your own custom objects.
1. Do not have a firewall preventing network I/O.

Journeta uses Ruby threading to manage the asynchronous nature of peer-to-peer I/O. Data you send from your application thread will be queued and sent asynrchonously as soon as possible. For insight into events internal to the library, start ruby with the `--debug` options.


## Bundled Sample Code


### Instant Messenger

A completely distributed, zero-configuration-required chat room script.

Fire up several instances in separate terminals. Multiple instances on the same machine is ok. Everything you type will automatically be sent to all other instances on the LAN! For detailed internal event details:

    ruby --debug journeta_instant_messenger.rb

### Network Status

Monitors the presence of all peers on the network.

	journeta_network_status.rb

### Distributed Master/Slave Job Queue

A simple queue managed by a server. Each client produces jobs to be queued, and processes jobs sent from the server(s). All nodes automatically find eachother. Try running multiples clients, and then multiple servers. Notice that when you have N servers, each job gets run N times, and not necessarilly by the same client!

	journeta_queue_server.rb
	journeta_queue_client.rb


## Author

Preston Lee

* https://www.leedoes.com
* https://www.github.com/preston
* http://twitter.com/prestonism
