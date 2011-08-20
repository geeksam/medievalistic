require 'bundler'
require 'rake/testtask'

task :default => 'test:all'

namespace :test do
	Rake::TestTask.new('all') do |t|
	  t.pattern = 'test/**/*_test.rb'
    t.warning = true
	end

	Rake::TestTask.new('integration') do |t|
	  t.pattern = 'test/integration/*_test.rb'
    t.warning = true
	end

	Rake::TestTask.new('unit') do |t|
	  t.pattern = 'test/unit/*_test.rb'
    t.warning = true
	end
end
