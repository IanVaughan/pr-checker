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

  create_table "branches", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.json "commit"
    t.boolean "merged"
    t.boolean "protected"
    t.boolean "developers_can_push"
    t.boolean "developers_can_merge"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_branches_on_project_id"
  end

  create_table "jobs", id: :serial, force: :cascade do |t|
    t.string "status", null: false
    t.string "stage", null: false
    t.string "name", null: false
    t.string "ref", null: false
    t.string "tag", null: false
    t.string "coverage"
    t.datetime "started_at", null: false
    t.datetime "finished_at", null: false
    t.json "user", default: {}
    t.json "commit", default: {}
    t.json "runner", default: {}
    t.json "pipeline", default: {}
    t.integer "pipeline_id"
    t.string "trace"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pipeline_id"], name: "index_jobs_on_pipeline_id"
  end

  create_table "merge_requests", id: :serial, force: :cascade do |t|
    t.integer "iid", null: false
    t.string "title", null: false
    t.string "description", null: false
    t.string "state", null: false
    t.string "web_url", null: false
    t.integer "project_id"
    t.json "info", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_merge_requests_on_project_id"
  end

  create_table "pipelines", id: :serial, force: :cascade do |t|
    t.string "sha", null: false
    t.string "ref", null: false
    t.string "status", null: false
    t.json "info", default: {}
    t.integer "project_id"
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
    t.string "name", null: false
    t.string "name_with_namespace", null: false
    t.string "path", null: false
    t.string "path_with_namespace", null: false
    t.integer "star_count"
    t.integer "forks_count"
    t.datetime "last_activity_at"
    t.json "info", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
