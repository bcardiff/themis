lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails-assets-urijs/version'

Gem::Specification.new do |spec|
  spec.name = 'rails-assets-urijs'
  spec.version = RailsAssetsUrijs::VERSION
  spec.authors = ['rails-assets.org']
  spec.description = ''
  spec.summary = ''
  spec.homepage = 'https://github.com/medialize/URI.js'
  spec.license = 'MIT'

  spec.files = `find ./* -type f | cut -b 3-`.split($/)
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
