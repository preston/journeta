# -*- encoding: utf-8 -*-
require File.expand_path('../lib/journeta/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Preston Lee"]
  gem.email         = "preston.lee@prestonlee.com"
  gem.description   = %q{Journeta is a dirt simple peer discovery and message passing library for processes on the same LAN, requiring no advanced networking knowledge to use. Only core Ruby libraries are required, making the library fairly light. As all data is sent across the wire in YAML form, so any arbitrary Ruby object can be sent to peers, written in any language.}
  gem.summary       = %q{A zero-configuration-required peer-to-peer (P2P) discovery and communications library for closed networks.}
  gem.homepage      = "https://github.com/preston/journeta"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "journeta"
  gem.require_paths = ["lib"]
  gem.licenses      = ["Apache 2.0"]
  gem.version       = Journeta::VERSION::STRING

  gem.add_development_dependency  'curses', '>= 1.0.1'
end
