require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module BuddyPix
  class Application < Rails::Application

    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{**}')]
    # config.autoload_paths += Dir[Rails.root.join('app', 'controllers', '{**}')]

    config.assets.precompile += %w[admin.css admin.js]
    config.generators do |g|
      g.javascripts false
      g.stylesheets false
      g.helper false
      g.view_specs false
      g.template_engine :haml
      g.test_framework :minitest, spec: true
    end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end
