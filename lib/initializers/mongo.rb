require "mongo_mapper"
require 'yaml'

RACK_ENV ||= "development"

settings = YAML.load(File.read(File.expand_path('../../config/mongo.yml', File.dirname(__FILE__))))["#{RACK_ENV}"]

MongoMapper.connection = Mongo::Connection.new(settings['host'], settings['port'])
MongoMapper.database = settings['database']
