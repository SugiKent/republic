source 'https://rubygems.org'
ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.1.6'
# Use mysql as the database for Active Record
gem 'mysql2', '< 0.5'

gem 'puma'
gem 'listen'

# image_tag_with_ampのため
gem 'fastimage'

# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

gem 'bootstrap-sass'

gem 'seed-fu'
gem 'execjs'
# マークダウンを簡単に実装するgem
gem 'redcarpet'

# ページネーション
gem 'kaminari'

# rails cを見やすく
gem 'hirb'
gem 'hirb-unicode'

# 画像アップロード
gem "carrierwave"

# slimの導入
gem 'slim-rails'

# Use jquery as the JavaScript library
gem 'jquery-rails'
#gem 'jquery-turbolinks'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt'

# Devise
gem 'devise'
gem 'sprockets'
gem 'devise-i18n-views'

# Use Unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# To manage meta tags
gem 'meta-tags'
gem 'dotenv-rails'

# exceptionを通知
gem 'exception_notification', :github => 'smartinez87/exception_notification'
# Slack通知
gem 'slack-notifier'

# パンくずを表示
gem 'gretel'

# PDF出力をする
gem 'wkhtmltopdf-binary-11'
gem 'wicked_pdf'

# 環境ごとの設定値を管理
gem 'config'

group :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'spring-commands-rspec'
  gem 'faker'
  gem 'rails-controller-testing'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'pry'
  gem 'pry-byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'

  # ローカルでmailを受信
  gem 'letter_opener'
  gem 'letter_opener_web'

end

group :staging do
  gem 'rails_12factor'
end
