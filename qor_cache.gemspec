# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'qor_cache/version'

Gem::Specification.new do |gem|
  gem.name          = "qor_cache"
  gem.version       = Qor::Cache::VERSION
  gem.authors       = ["Jinzhu"]
  gem.email         = ["wosmvp@gmail.com"]
  gem.description   = %q{Qor Cache}
  gem.summary       = %q{Qor Cache}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "qor_test"
  gem.add_dependency "qor_dsl"
  gem.add_dependency "rails"
  gem.add_development_dependency "sqlite3"
end
