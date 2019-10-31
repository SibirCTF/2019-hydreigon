Hanami::Model.migration do
  change do
    create_table :analitycs do
      primary_key :id, :uuid, default: Sequel.function(:uuid_generate_v4)
      column :query_string, String
      column :request_method, String
      column :request_path, String
      column :request_uri, String
      column :http_version, String
      column :http_host, String
      column :http_user_agent, String
      column :http_origin, String
      column :http_cookie, String
      column :http_connection, String
      column :path_info, String
      column :remote_addr, String
      column :created_at, DateTime, null: false, default: Time.now
      column :updated_at, DateTime, null: false, default: Time.now
    end
  end
end
