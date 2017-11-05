class CreateProjects < ActiveRecord::Migration[5.0]
  def self.up
    # enable_extension :hstore

    create_table :projects, force: true do |t|
      t.string :description
      t.string :default_branch
      t.string :tag_list, array: true
      t.string :ssh_url_to_repo
      t.string :http_url_to_repo
      t.string :web_url
      t.string :name, null: false
      t.string :name_with_namespace, null: false
      t.string :path, null: false
      t.string :path_with_namespace, null: false
      t.integer :star_count
      t.integer :forks_count
      t.datetime :last_activity_at
      t.json :info, default: {}
      t.timestamps
    end

    create_table :branches, force: true do |t|
      t.string :name, null: false
      t.json :commit
      t.boolean :merged
      t.boolean :protected
      t.boolean :developers_can_push
      t.boolean :developers_can_merge
      t.references :project
      t.timestamps
    end

    create_table :pipelines, force: true do |t|
      t.string :sha, null: false
      t.string :ref, null: false
      t.string :status, null: false
      t.json :info, default: {}
      t.references :project
      t.timestamps
    end

    create_table :merge_requests, force: true do |t|
      t.integer :iid, null: false
      t.string :title, null: false
      t.string :description
      t.string :state, null: false
      t.string :web_url, null: false
      t.references :project
      t.json :info, default: {}
      t.timestamps
    end

    create_table :notes, force: true do |t|
      t.string :body
      t.string :attachment
      t.json :author, default: {}
      t.boolean :system
      t.integer :noteable_id
      t.string :noteable_type
      t.integer :noteable_iid
      t.references :merge_request
      t.timestamps
    end

    create_table :jobs, force: true do |t|
      t.string :status, null: false
      t.string :stage, null: false
      t.string :name, null: false
      t.string :ref, null: false
      t.string :tag, null: false
      t.string :coverage
      t.datetime :started_at
      t.datetime :finished_at

      t.json :user, default: {}
      t.json :commit, default: {}
      t.json :runner, default: {}
      t.json :pipeline, default: {}

      t.references :pipeline
      t.string :trace
      t.timestamps
    end
  end

  def self.down
  end
end
