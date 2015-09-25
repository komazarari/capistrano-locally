# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/locally/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-locally"
  spec.version       = Capistrano::Locally::VERSION
  spec.authors       = ["Takuto Komazaki"]
  spec.email         = ["komazarari@gmail.com"]

  spec.summary       = %q{Capistrano plugin to simplify "localhost" deployment.}
  spec.description   = %q{Capistrano plugin to simplify "localhost" deployment.}
  spec.homepage      = "https://github.com/komazarari/capistrano-locally"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
