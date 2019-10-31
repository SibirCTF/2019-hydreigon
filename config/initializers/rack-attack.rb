# frozen_string_literal: true

Rack::Attack.cache.store = Rack::Attack::StoreProxy::RedisProxy.new(
  Redis.new(uri: ENV['REDIS_URL'] || 'redis://127.0.0.1:6379')
)

Rack::Attack.throttle('/', limit: 10, period: 10) do |req|
  req.user_agent unless req.env['REQUEST_PATH'].include?('assets')
end

ip_safelist = ['123.2.2.1']
Rack::Attack.safelist('allow from our safelist') { |request| ip_safelist.include? request.ip }
