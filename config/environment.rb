require 'bundler/setup'
require 'hanami/setup'
require 'hanami/model'
require_relative '../lib/distruct'
require_relative '../apps/web/application'
require_relative '../apps/analitycs/application'
require_relative '../apps/middleware/payloads_middleware'

Hanami.configure do
  # `analytics` -> SHA-1 -> `66d9b558f41b30033e4d62bf47d52885e31627e4`
  mount Analitycs::Application, at: '/66d9b558f41b30033e4d62bf47d52885e31627e4'
  mount Web::Application, at: '/'

  model do
    ##
    # Database adapter
    #
    # Available options:
    #
    #  * SQL adapter
    #    adapter :sql, 'sqlite://db/distruct_development.sqlite3'
    #    adapter :sql, 'postgresql://localhost/distruct_development'
    #    adapter :sql, 'mysql://localhost/distruct_development'
    #
    adapter :sql, ENV.fetch('DATABASE_URL')

    ##
    # Migrations
    #
    migrations 'db/migrations'
    schema     'db/schema.sql'
  end

  middleware.use Rack::Attack
  middleware.use PayloadsMiddleware

  mailer do
    root 'lib/distruct/mailers'

    # See https://guides.hanamirb.org/mailers/delivery
    delivery :test
  end

  environment :development do
    # See: https://guides.hanamirb.org/projects/logging
    logger level: :debug
  end

  environment :production do
    logger level: :warn, formatter: :json, filter: %w[text]
  end
end
