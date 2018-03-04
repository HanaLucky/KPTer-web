# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( mdl/1.3.0/material.kpter-pink.min.css )
Rails.application.config.assets.precompile += %w( mdl/mdl-selectfield.js )

Rails.application.config.assets.precompile += %w( style.css )

# welcome/index.html.erb
Rails.application.config.assets.precompile += %w( theDocs/1.4.0/theDocs.all.js )
Rails.application.config.assets.precompile += %w( theDocs/1.4.0/theDocs.all.css )
Rails.application.config.assets.precompile += %w( welcome/welcome.css )
Rails.application.config.assets.precompile += %w( theDocs/1.4.0/skin/skin-teal.css )


Rails.application.config.assets.precompile += %w( jquery.js )

# sp/index.html.erb用CSS
Rails.application.config.assets.precompile += %w( sp/creative.css )
Rails.application.config.assets.precompile += %w( sp/creative.min.css )
Rails.application.config.assets.precompile += %w( sp/style.css )
Rails.application.config.assets.precompile += %w( sp/font-awesome/css/font-awesome.min.css )
Rails.application.config.assets.precompile += %w( sp/bootstrap/css/bootstrap.min.css )
Rails.application.config.assets.precompile += %w( sp/magnific-popup/magnific-popup.css )

# sp/index.html.erb用JS
Rails.application.config.assets.precompile += %w( sp/creative.js )
Rails.application.config.assets.precompile += %w( sp/jquery/jquery.min.js )
Rails.application.config.assets.precompile += %w( sp/bootstrap/js/bootstrap.min.js )
Rails.application.config.assets.precompile += %w( sp/scrollreveal/scrollreveal.min.js )
Rails.application.config.assets.precompile += %w( sp/magnific-popup/jquery.magnific-popup.min.js )

# Communitiesページ用
Rails.application.config.assets.precompile += %w( communities.js )

# MyPageページ用
Rails.application.config.assets.precompile += %w( mypages.js )

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
