# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'domp/version'

Gem::Specification.new do |gem|
  gem.name  = "domp"
  gem.version = Domp::VERSION
  gem.license = 'MIT'
  gem.authors = ["Alexander Zaytsev"]
  gem.email = ["alexander@say26.com"]
  gem.description = %q{Devise Omniauth Multiple Providers}
  gem.summary = %q{Generator to bootstrap usage of multiple providers with Devise and Omniauth}
  gem.homepage = "https://github.com/AlexanderZaytsev/domp"

  gem.files = `git ls-files`.split($/)
  gem.executables = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
