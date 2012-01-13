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
require 'yard'

Jeweler::Tasks.new do |gem|
  gem.name = 'yard-chef'
  gem.summary = %Q{YARD plugin for Chef}
  gem.description = <<EOS
yard-chef is a YARD plugin for Chef that adds support for documenting Chef resources, providers, and definitions.}
EOS
  gem.email = 'douglas@rightscale.com'
  gem.homepage = 'https://github.com/rightscale/yard-chef'
  gem.authors = ['Douglas Thrift', 'Nick Stakanov']
end
Jeweler::RubygemsDotOrgTasks.new

YARD::Rake::YardocTask.new

task :default
