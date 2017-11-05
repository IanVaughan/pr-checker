class AddSystemHooks < ActiveRecord::Migration[5.0]
  def self.up
    create_table :system_hooks, force: true do |t|
      t.string :url, null: false
      t.boolean :push_events
      t.boolean :tag_push_events
      t.boolean :repository_update_events
      t.boolean :enable_ssl_verification

      t.timestamps
    end
  end

  def self.down
  end
end
