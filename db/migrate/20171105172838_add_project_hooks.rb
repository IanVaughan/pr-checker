class AddProjectHooks < ActiveRecord::Migration[5.0]
  def self.up
    create_table :project_hooks, force: true do |t|
      t.string :url, null: false
      t.boolean :push_events
      t.boolean :tag_push_events
      t.boolean :repository_update_events
      t.boolean :enable_ssl_verification

      t.references :project
      t.boolean :issues_events
      t.boolean :merge_requests_events
      t.boolean :note_events
      t.boolean :pipeline_events
      t.boolean :wiki_page_events
      t.boolean :job_events

      t.timestamps
    end
  end

  def self.down
  end
end
