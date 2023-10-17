lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails-assets-q/version'

Gem::Specification.new do |spec|
  spec.name = 'rails-assets-q'
  spec.version = RailsAssetsQ::VERSION
  spec.authors = ['rails-assets.org']
  spec.description = ''
  spec.summary = ''
  spec.homepage = 'https://github.com/kriskowal/q'

  spec.files = `find ./* -type f | cut -b 3-`.split($/)
  spec.require_paths = ['lib']

  spec.post_install_message = "This component doesn't define main assets in bower.json.\nPlease open new pull request in component's repository:\nhttps://github.com/kriskowal/q"

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
