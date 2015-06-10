#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rake/testtask'


Rake::TestTask.new do |t|
    t.pattern = "spec/*_spec.rb"
end

task :default => [:test, :build]

task :irb do
  sh "irb -I lib -r frb"
  sh "reset"
end
