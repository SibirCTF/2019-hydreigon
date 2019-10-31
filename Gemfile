# frozen_string_literal: true

source 'https://rubygems.org'

gem 'aescrypt', '~> 1.0'
gem 'dotenv', '~> 2.4'
gem 'hanami', '~> 1.3'
gem 'hanami-model', '~> 1.3'
gem 'pg'
gem 'rack-attack', '~> 6.2'
gem 'rake'
gem 'redis', '~> 4.1'

group :development do
  gem 'hanami-webconsole'
  gem 'pry', '~> 0.12.2'
  gem 'rubocop', '~> 0.75.0'
  gem 'shotgun', platforms: :ruby
end

group :production do
  gem 'puma'
end

group :test do
  gem 'capybara'
  gem 'rspec-hanami'
end
