#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rake/testtask'


Rake::TestTask.new do |t|
    t.pattern = "spec/*_spec.rb"
end

task :clean do
    rm_rf "pkg"
end

task :default => [:test, :build]

task :irb do
  sh "irb -I lib -r expletive"
  sh "reset"
end
