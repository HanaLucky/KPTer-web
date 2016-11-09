# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( communities/show.js )
Rails.application.config.assets.precompile += %w( dataTablesSetting.js )
Rails.application.config.assets.precompile += %w( tasksTable.js )
# Welcome/index.html.erb用CSS
Rails.application.config.assets.precompile += %w( welcome/creative.css )
Rails.application.config.assets.precompile += %w( welcome/creative.min.css )
Rails.application.config.assets.precompile += %w( welcome/style.css )
Rails.application.config.assets.precompile += %w( welcome/font-awesome/css/font-awesome.min.css )
Rails.application.config.assets.precompile += %w( welcome/bootstrap/css/bootstrap.min.css )
Rails.application.config.assets.precompile += %w( welcome/magnific-popup/magnific-popup.css )
# Welcome/index.html.erb用JS
Rails.application.config.assets.precompile += %w( welcome/creative.js )
Rails.application.config.assets.precompile += %w( welcome/jquery/jquery.min.js )
Rails.application.config.assets.precompile += %w( welcome/bootstrap/js/bootstrap.min.js )
Rails.application.config.assets.precompile += %w( welcome/scrollreveal/scrollreveal.min.js )
Rails.application.config.assets.precompile += %w( welcome/magnific-popup/jquery.magnific-popup.min.js )
