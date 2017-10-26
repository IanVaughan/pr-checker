require "mongo_mapper"

MongoMapper.connection = Mongo::Connection.new(ENV['DATABASE_HOST'], ENV['DATABASE_PORT'])
MongoMapper.database = ENV['DATABASE_NAME']
