# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171101211101) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "jobs", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "pipeline_id"
    t.json "info", default: {}
    t.string "trace"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pipeline_id"], name: "index_jobs_on_pipeline_id"
  end

  create_table "merge_requests", id: :serial, force: :cascade do |t|
    t.string "title"
    t.integer "project_id"
    t.json "info", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_merge_requests_on_project_id"
  end

  create_table "pipelines", id: :serial, force: :cascade do |t|
    t.integer "project_id"
    t.json "info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_pipelines_on_project_id"
  end

  create_table "projects", id: :serial, force: :cascade do |t|
    t.string "description"
    t.string "default_branch"
    t.string "tag_list", array: true
    t.string "ssh_url_to_repo"
    t.string "http_url_to_repo"
    t.string "web_url"
    t.string "name"
    t.string "name_with_namespace"
    t.string "path"
    t.string "path_with_namespace"
    t.integer "star_count"
    t.integer "forks_count"
    t.datetime "last_activity_at"
    t.json "info", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
