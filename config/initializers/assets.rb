# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( simple_template.scss modules/pdf/pdf.scss amp/amp_classes/lesson.css )

# AMP用CSS
amp_css_paths = Dir.entries("#{Rails.application.config.root}/app/assets/stylesheets/amp").select { |name| name =~ /css$/ }.map { |name| "amp/#{name}" }
Rails.application.config.assets.precompile += amp_css_paths
