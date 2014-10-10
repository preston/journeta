# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'journeta/version'

Gem::Specification.new do |spec|
  spec.authors       = ["Preston Lee"]
  spec.email         = "preston.lee@prestonlee.com"
  spec.description   = %q{Journeta is a dirt simple peer discovery and message passing library for processes on the same LAN, requiring no advanced networking knowledge to use. Only core Ruby libraries are required, making the library fairly light. As all data is sent across the wire in YAML form, so any arbitrary Ruby object can be sent to peers, written in any language.}
  spec.summary       = %q{A zero-configuration-required peer-to-peer (P2P) discovery and communications library for closed networks.}
  spec.homepage      = "https://github.com/preston/journeta"

  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.name          = "journeta"
  spec.require_paths = ["lib"]
  spec.licenses      = ["Apache 2.0"]
  spec.version       = Journeta::VERSION

  spec.add_development_dependency 'curses', '>= 1.0.1'
  spec.add_development_dependency 'bundler', '>= 1.7.3'
  spec.add_development_dependency 'rake', '10.3.2'
end
