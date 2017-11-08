require 'active_record'
require 'logger'

# ActiveRecord::Base.logger = Logger.new("log/active_record_#{ENV['RACK_ENV']}.log")
configuration = YAML::load(IO.read('config/database.yml'))
puts "-- DATABASE_URL:#{ENV['DATABASE_URL']}"
puts "-- configuration:#{configuration[ENV['RACK_ENV']]}"
ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || configuration[ENV['RACK_ENV']])
