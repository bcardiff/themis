require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Themis
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = Settings.time_zone || 'Buenos Aires'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = 'es-AR'

    # Do not swallow errors in after_commit/after_rollback callbacks.

    config.generators.stylesheets = false
    config.generators.javascripts = false
    config.generators.helper = false

    config.action_mailer.default_url_options = Settings.default_url_options.to_h
    config.action_mailer.asset_host = "http://#{Settings.default_url_options.host}"

    config.autoload_paths << Rails.root.join('lib')
    config.autoload_paths << "#{Rails.root}/actions"

    config.react.addons = true

    config.active_job.queue_adapter = :async
    config.assets.paths << Rails.root.join("vendor")
    config.assets.precompile += %w( *.scss )

  end
end
