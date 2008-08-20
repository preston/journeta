ABOUT
=====

Journeta is a dirt simple peer discovery and message passing library for processes on the same LAN,
requiring no advanced networking knowledge to use.

Only core Ruby libraries are required, making the library fairly light. As all data is sent accross
the wire in YAML form, any arbitrary Ruby object can be sent to peers, provided they..

* Are running a compatible Journeta version, and
* Have access to the same class definitions if you are sending your own custom objects.
* Do not have a firewall preventing

Journeta uses Ruby threading to manage the asynchonous nature of peer-to-peer I/O.
For insight into events internal to the library, start ruby with the `--debug` options.


USAGE
=====

 examples/instant_messenger.rb
 
    A completely distributed, zero-configuration-required chat room script.
    Fire up several instances in separate terminals. Multiple instances on the same machine is ok.
    Everything you type will automatically be sent to all other instances on the LAN!
    Use `ruby --debug examples/instant_messenger.rb` for detailed internal event details.


AUTHOR
======

Preston Lee <preston.lee at openrain d0t com>
http://www.prestonlee.com
http://www.openrain.com


LINKS
=====

How Journeta discovers peers using UDP multicasting..
http://onestepback.org/index.cgi/Tech/Ruby/MulticastingInRuby.red
