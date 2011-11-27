require "bundler/gem_tasks"

require "bundler/setup"


task :default => :spec

require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = '--colour --format doc'
end

task :default => :spec