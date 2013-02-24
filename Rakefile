require 'rake/testtask'

desc "Run all tests"
task :default => :testall

desk "Run all of the tests"
task :testall => [:test, :examples]

desc "Run the unit tests"
Rake::TestTask.new do |t|
  t.libs.push "lib", "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

desc "Run the examples"
task :examples do
  Dir["examples/*.sh"].each do |script|
    sh script
  end
end

begin
  require 'bundler'
  Bundler::GemHelper.install_tasks
rescue
  STDERR.puts "bundler is not available"
end
