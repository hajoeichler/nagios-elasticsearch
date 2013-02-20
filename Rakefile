# -*- mode: ruby -*-

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:test) do |t|
  t.rspec_opts = [ '--format documentation', '--color' ]
  t.pattern = "./spec/**/*_spec.rb"
  t.verbose = true
end

task :default => :test

