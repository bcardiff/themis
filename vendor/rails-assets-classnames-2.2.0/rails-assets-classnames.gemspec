# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails-assets-classnames/version'

Gem::Specification.new do |spec|
  spec.name          = "rails-assets-classnames"
  spec.version       = RailsAssetsClassnames::VERSION
  spec.authors       = ["rails-assets.org"]
  spec.description   = "A simple utility for conditionally joining classNames together"
  spec.summary       = "A simple utility for conditionally joining classNames together"
  spec.homepage      = "https://github.com/JedWatson/classnames"
  spec.license       = "MIT"

  spec.files         = `find ./* -type f | cut -b 3-`.split($/)
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
