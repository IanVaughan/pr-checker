class CreateProjects < ActiveRecord::Migration[5.0]
  def self.up
    enable_extension :hstore

    create_table :projects, force: true do |t|
    # create_table :projects, force: true, id: false do |t|
      # t.integer :project_id
      # t.integer :id, options: 'PRIMARY KEY', null: false
      # t.integer :id, primary: true
      # t.integer :id, null: false
      t.string :description
      t.string :default_branch
      t.string :tag_list, array: true
      t.string :ssh_url_to_repo
      t.string :http_url_to_repo
      t.string :web_url
      t.string :name
      t.string :name_with_namespace
      t.string :path
      t.string :path_with_namespace
      t.integer :star_count
      t.integer :forks_count
      t.datetime :last_activity_at

      t.hstore :info

      t.timestamps
    end
    # execute %Q{ ALTER TABLE "projects" ADD PRIMARY KEY ("id"); }
    # add_index :projects, :id, unique: true

    create_table :pipelines, force: true do |t|
      t.references :project
      t.hstore :info
      t.timestamps
    end

    create_table :merge_requests, force: true do |t|
      t.string :title
      t.references :project
      t.hstore :info
      t.timestamps
    end

    create_table :jobs, force: true do |t|
      t.string :name
      t.references :pipeline
      t.hstore :info
      t.string :trace
      t.timestamps
    end
  end

  def self.down
  end
end
