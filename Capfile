require 'capistrano/setup'
require 'capistrano/deploy'
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git
require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'

# require 'capistrano3/unicorn'
# require 'capistrano/rvm'
# require 'capistrano/chruby'
# require 'capistrano/passenger'

# taskを記述したファイルを読み込むよう設定。　場所と拡張子を指定。
Dir.glob('lib/capistrano/tasks/*.rb').each { |r| import r }
