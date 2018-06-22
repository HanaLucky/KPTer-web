require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Kpter
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    # redis
    config.session_store :redis_store, servers: 'redis://redis:6379/0', expire_in: 1.day

    # form_for が勝手に出力する<div class="field_with_errors"></div>を制御し、デザイン崩れを防止する
    # see. http://guides.rubyonrails.org/configuring.html#configuring-action-view
    config.action_view.field_error_proc = Proc.new do |html_tag, instance|
      %Q(#{html_tag}).html_safe
    end

    # remember me enabled by default
    config.remember_me_enable_by_default = true
    config.x.settings = Rails.application.config_for :settings
  end
end
