require 'bundler'
require 'rake/testtask'

task :default => 'test:all'

namespace :test do
  desc "Run all tests"
  task :all => %w[unit integration]

	Rake::TestTask.new('integration') do |t|
	  t.pattern = 'test/integration/*.rb'
    t.warning = true
	end

	Rake::TestTask.new('unit') do |t|
	  t.pattern = 'test/unit/*_test.rb'
    t.warning = true
	end
end
