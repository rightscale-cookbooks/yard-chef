# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.name        = "yard-chef"
  gem.version     = IO.read(File.join(File.dirname(__FILE__), "VERSION")).chomp
  gem.platform    = Gem::Platform::RUBY
  gem.authors     = [ "Nitin Mohan" ]
  gem.email       = [ "nitin@rightscale.com" ]
  gem.homepage    = "https://github.com/rightscale/yard-chef"
  gem.summary     = %q{YARD plugin for Chef}
  gem.description = %q{yard-chef is a YARD plugin for Chef that adds support for documenting Chef recipes, lightweight resources and providers, libraries and definitiongem.}
  gem.license     = "MIT"

  gem.add_runtime_dependency 'yard', '~> 0.7'
  gem.add_runtime_dependency 'redcarpet', '~> 2.1.1'
  
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
