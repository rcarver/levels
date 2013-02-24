# -*- encoding: utf-8 -*-
require File.expand_path('../lib/levels/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ryan Carver"]
  gem.email         = ["ryan@ryancarver.com"]
  gem.description   = %q{A tool for reading and writing configuration data.}
  gem.summary       = %q{A tool for reading and writing configuration data.}
  gem.homepage      = "https://github.com/rcarver/levels"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "levels"
  gem.require_paths = ["lib"]
  gem.version       = Levels::VERSION

  gem.add_development_dependency "rake"
  gem.add_development_dependency "minitest", "~>4.0"
end
