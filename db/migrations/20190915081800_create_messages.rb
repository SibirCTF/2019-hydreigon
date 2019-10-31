Hanami::Model.migration do
  change do
    create_table :messages do
      primary_key :id, :uuid, default: Sequel.function(:uuid_generate_v4)
      column :text, String
      column :clicks_left, Integer, default: 1
      column :self_destruction_time, DateTime
      column :client_password, String
      column :remove, TrueClass, default: false

      column :created_at, DateTime, null: false, default: Time.now
      column :updated_at, DateTime, null: false, default: Time.now
    end
  end
end
