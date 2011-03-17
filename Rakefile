require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "journeta"
  gem.homepage = "http://github.com/preston/journeta"
  gem.license = "Apache 2.0"
  gem.summary = %Q{A zero-configuration-required peer-to-peer (P2P) discovery and communications library for closed networks.}
  gem.description = %Q{Journeta is a dirt simple peer discovery and message passing library for processes on the same LAN, requiring no advanced networking knowledge to use. Only core Ruby libraries are required, making the library fairly light. As all data is sent across the wire in YAML form, so any arbitrary Ruby object can be sent to peers, written in any language.}
  gem.email = "conmotto@gmail.com"
  gem.authors = ["Preston Lee"]
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  #  gem.add_runtime_dependency 'jabber4r', '> 0.1'
  #  gem.add_development_dependency 'rspec', '> 1.2.3'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  # version = File.exist?('VERSION') ? File.read('VERSION') : ""
	require File.dirname(__FILE__) + '/lib/journeta/version'
	version = 
	

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "journeta #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
