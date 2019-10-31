# frozen_string_literal: true

class PayloadsMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    safe_user_info(env)
    @app.call(env)
  end

  private

  def safe_user_info(env)
    request_path = env['REQUEST_PATH']
    # write only root and message endpoint to analitycs
    return unless (request_path == '/') || request_path.include?('messages')

    t = Time.now
    db = Sequel.connect(ENV.fetch('DATABASE_URL'))
    fast_sql = %{
      INSERT INTO analitycs (query_string, request_method, request_path, request_uri, http_version, http_host,
      http_user_agent, http_origin, http_cookie, http_connection, path_info, remote_addr, created_at, updated_at
    ) VALUES (
      '#{env['QUERY_STRING']}', '#{env['REQUEST_METHOD']}', '#{env['REQUEST_PATH']}', '#{env['REQUEST_URI']}', '#{env['HTTP_VERSION']}',
      '#{env['HTTP_HOST']}', '#{env['HTTP_USER_AGENT']}', '#{env['HTTP_ORIGIN']}', '#{env['HTTP_COOKIE']}', '#{env['HTTP_CONNECTION']}',
      '#{env['PATH_INFO']}', '#{env['REMOTE_ADDR']}', '#{t}', '#{t}' );}
    db.execute(fast_sql)
  end
end
