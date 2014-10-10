require "bundler/gem_tasks"



require 'rake/testtask'
 
Rake::TestTask.new do |t|
  t.libs << 'lib/sms-easy'
  t.test_files = FileList['test/lib/sms-easy/*_test.rb']
  t.verbose = true
end
 
task :default => :test
