require 'bundler'
Bundler.require

require 'active_record'
require 'rake'
require 'colorize'
require 'colorized_string'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'
