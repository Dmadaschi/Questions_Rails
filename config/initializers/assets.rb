# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.

Rails.application.config.assets.precompile += %w[custom.min.js custom.css]
Rails.application.config.assets.precompile += %w[sb-admin.js sb-admin.css]
Rails.application.config.assets.precompile += %w[img.jpg]


Rails.application.config.assets.precompile += %w[
  admins_backoffice.js
  admins_backoffice.css
  admin_devise.js
  admin_devise.css
]
Rails.application.config.assets.precompile += %w[
  users_backoffice.js
  users_backoffice.css
]

Rails.application.config.assets.precompile += %w[jquery-2.2.3/dist/jquery.js
                                                 bootstrap-4.3.1/dist/js/bootstrap.js]
