require File.expand_path('../boot', __FILE__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
require 'action_cable/engine'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Kpter
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 'Tokyo'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    # active record timezone
    config.active_record.default_timezone = :local
    # autoload paths
    config.autoload_paths = %W(#{config.root}/app/forms)
    config.autoload_paths = %W(#{config.root}/app/services)
    config.autoload_paths = %W(#{config.root}/app/lib)

    # TODO 本番設定も記載する
    # redis
    config.session_store :redis_store, servers: 'redis://localhost:6379/0', expire_in: 1.day

    # form_for が勝手に出力する<div class="field_with_errors"></div>を制御し、デザイン崩れを防止する
    # see. http://guides.rubyonrails.org/configuring.html#configuring-action-view
    config.action_view.field_error_proc = Proc.new { |html_tag, instance| %Q(#{html_tag}).html_safe }

    # remember me enabled by default
    config.remember_me_enable_by_default = true
  end
end
