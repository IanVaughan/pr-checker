source 'https://rubygems.org'

ruby '2.4.1'

gem 'sinatra'
gem 'json'
gem 'octokit'
gem 'dotenv'

gem 'rake'

gem 'gitlab'
gem 'sidekiq'
gem 'rack'
gem 'activerecord'
gem 'pg'

group :test, :development do
  gem 'pry'
  gem 'guard'
  gem 'guard-rspec', require: false
end

group :test do
  gem 'rack-test'
  gem 'rspec'
  gem 'webmock'
  gem 'database_cleaner'
end
