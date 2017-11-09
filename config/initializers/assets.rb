# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( mdl/1.3.0/material.kpter-pink.min.css )
Rails.application.config.assets.precompile += %w( dialog-polyfill/0.4.9/dialog-polyfill.css )
Rails.application.config.assets.precompile += %w( dialog-polyfill/0.4.9/dialog-polyfill.js )

Rails.application.config.assets.precompile += %w( list.js )

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

# Communitiesページ用CSS
Rails.application.config.assets.precompile += %w( communities.css )
Rails.application.config.assets.precompile += %w( invite_other.css )

# Boardsページ用JS
Rails.application.config.assets.precompile += %w( cable.js )
Rails.application.config.assets.precompile += %w( channels/board.coffee )
Rails.application.config.assets.precompile += %w( boards/cards.coffee )
Rails.application.config.assets.precompile += %w( boards/card.js )

# Boardsページ用CSS
Rails.application.config.assets.precompile += %w( boards/style.css )
Rails.application.config.assets.precompile += %w( boards/default.css )
Rails.application.config.assets.precompile += %w( boards/component.css )

# users
Rails.application.config.assets.precompile += %w( fine-uploader/5.15.0/fine-uploader.core.js )
Rails.application.config.assets.precompile += %w( fine-uploader/5.15.0/fine-uploader.core.js.map )
Rails.application.config.assets.precompile += %w( users/edit.js )
Rails.application.config.assets.precompile += %w( users/edit.css )

# debugger用CSS
Rails.application.config.assets.precompile += %w( debugger.css )
