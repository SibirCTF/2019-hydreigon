workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)
threads threads_count, threads_count
ssl_bind ENV['HOST'] || '0.0.0.0', '2300', {
  key: 'public/server.key',
  cert: 'public/server.crt'
}
preload_app!
