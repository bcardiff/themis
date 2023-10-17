lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails-assets-sass-flex-mixin/version'

Gem::Specification.new do |spec|
  spec.name = 'rails-assets-sass-flex-mixin'
  spec.version = RailsAssetsSassFlexMixin::VERSION
  spec.authors = ['rails-assets.org']
  spec.description = ''
  spec.summary = ''
  spec.homepage = 'https://github.com/mastastealth/sass-flex-mixin'
  spec.license = 'MIT'

  spec.files = `find ./* -type f | cut -b 3-`.split($/)
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
