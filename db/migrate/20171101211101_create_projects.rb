class CreateProjects < ActiveRecord::Migration[5.0]
  def self.up
    enable_extension :hstore

    create_table :projects, force: true do |t|
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
      t.json :info, default: {}
      t.timestamps
    end

    create_table :pipelines, force: true do |t|
      t.references :project
      t.json :info
      t.timestamps
    end

    create_table :merge_requests, force: true do |t|
      t.string :title
      t.references :project
      t.json :info, default: {}
      t.timestamps
    end

    create_table :jobs, force: true do |t|
      t.string :name
      t.references :pipeline
      t.json :info, default: {}
      t.string :trace
      t.timestamps
    end
  end

  def self.down
  end
end
