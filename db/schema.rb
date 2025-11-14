# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_11_14_170832) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_stat_statements"

  create_table "blazer_audits", force: :cascade do |t|
    t.datetime "created_at"
    t.string "data_source"
    t.bigint "query_id"
    t.text "statement"
    t.bigint "user_id"
    t.index ["query_id"], name: "index_blazer_audits_on_query_id"
    t.index ["user_id"], name: "index_blazer_audits_on_user_id"
  end

  create_table "blazer_checks", force: :cascade do |t|
    t.string "check_type"
    t.datetime "created_at", null: false
    t.bigint "creator_id"
    t.text "emails"
    t.datetime "last_run_at"
    t.text "message"
    t.bigint "query_id"
    t.string "schedule"
    t.text "slack_channels"
    t.string "state"
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_checks_on_creator_id"
    t.index ["query_id"], name: "index_blazer_checks_on_query_id"
  end

  create_table "blazer_dashboard_queries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "dashboard_id"
    t.integer "position"
    t.bigint "query_id"
    t.datetime "updated_at", null: false
    t.index ["dashboard_id"], name: "index_blazer_dashboard_queries_on_dashboard_id"
    t.index ["query_id"], name: "index_blazer_dashboard_queries_on_query_id"
  end

  create_table "blazer_dashboards", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "creator_id"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_dashboards_on_creator_id"
  end

  create_table "blazer_queries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "creator_id"
    t.string "data_source"
    t.text "description"
    t.string "name"
    t.text "statement"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_queries_on_creator_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "address_1"
    t.string "address_2"
    t.datetime "archived_at"
    t.string "city"
    t.string "country"
    t.datetime "created_at", null: false
    t.string "direct_phone_number"
    t.string "email_address_1"
    t.string "email_address_2"
    t.string "fax_phone_number"
    t.string "first_name"
    t.string "last_name"
    t.string "middle_name"
    t.text "notes"
    t.string "office_phone_number"
    t.string "prefix"
    t.string "state"
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "zip_code"
  end

  create_table "data_logs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "loggable_id", null: false
    t.string "loggable_type", null: false
    t.jsonb "meta"
    t.text "note"
    t.string "operation"
    t.jsonb "original_data"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["loggable_type", "loggable_id"], name: "index_data_logs_on_loggable"
    t.index ["user_id"], name: "index_data_logs_on_user_id"
  end

  create_table "good_job_batches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "callback_priority"
    t.text "callback_queue_name"
    t.datetime "created_at", null: false
    t.text "description"
    t.datetime "discarded_at"
    t.datetime "enqueued_at"
    t.datetime "finished_at"
    t.datetime "jobs_finished_at"
    t.text "on_discard"
    t.text "on_finish"
    t.text "on_success"
    t.jsonb "serialized_properties"
    t.datetime "updated_at", null: false
  end

  create_table "good_job_executions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "active_job_id", null: false
    t.datetime "created_at", null: false
    t.interval "duration"
    t.text "error"
    t.text "error_backtrace", array: true
    t.integer "error_event", limit: 2
    t.datetime "finished_at"
    t.text "job_class"
    t.uuid "process_id"
    t.text "queue_name"
    t.datetime "scheduled_at"
    t.jsonb "serialized_params"
    t.datetime "updated_at", null: false
    t.index ["active_job_id", "created_at"], name: "index_good_job_executions_on_active_job_id_and_created_at"
    t.index ["process_id", "created_at"], name: "index_good_job_executions_on_process_id_and_created_at"
  end

  create_table "good_job_processes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "lock_type", limit: 2
    t.jsonb "state"
    t.datetime "updated_at", null: false
  end

  create_table "good_job_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "key"
    t.datetime "updated_at", null: false
    t.jsonb "value"
    t.index ["key"], name: "index_good_job_settings_on_key", unique: true
  end

  create_table "good_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "active_job_id"
    t.uuid "batch_callback_id"
    t.uuid "batch_id"
    t.text "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "cron_at"
    t.text "cron_key"
    t.text "error"
    t.integer "error_event", limit: 2
    t.integer "executions_count"
    t.datetime "finished_at"
    t.boolean "is_discrete"
    t.text "job_class"
    t.text "labels", array: true
    t.datetime "locked_at"
    t.uuid "locked_by_id"
    t.datetime "performed_at"
    t.integer "priority"
    t.text "queue_name"
    t.uuid "retried_good_job_id"
    t.datetime "scheduled_at"
    t.jsonb "serialized_params"
    t.datetime "updated_at", null: false
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["batch_callback_id"], name: "index_good_jobs_on_batch_callback_id", where: "(batch_callback_id IS NOT NULL)"
    t.index ["batch_id"], name: "index_good_jobs_on_batch_id", where: "(batch_id IS NOT NULL)"
    t.index ["concurrency_key", "created_at"], name: "index_good_jobs_on_concurrency_key_and_created_at"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at_cond", where: "(cron_key IS NOT NULL)"
    t.index ["cron_key", "cron_at"], name: "index_good_jobs_on_cron_key_and_cron_at_cond", unique: true, where: "(cron_key IS NOT NULL)"
    t.index ["finished_at"], name: "index_good_jobs_jobs_on_finished_at", where: "((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL))"
    t.index ["job_class"], name: "index_good_jobs_on_job_class"
    t.index ["labels"], name: "index_good_jobs_on_labels", where: "(labels IS NOT NULL)", using: :gin
    t.index ["locked_by_id"], name: "index_good_jobs_on_locked_by_id", where: "(locked_by_id IS NOT NULL)"
    t.index ["priority", "created_at"], name: "index_good_job_jobs_for_candidate_lookup", where: "(finished_at IS NULL)"
    t.index ["priority", "created_at"], name: "index_good_jobs_jobs_on_priority_created_at_when_unfinished", order: { priority: "DESC NULLS LAST" }, where: "(finished_at IS NULL)"
    t.index ["priority", "scheduled_at"], name: "index_good_jobs_on_priority_scheduled_at_unfinished_unlocked", where: "((finished_at IS NULL) AND (locked_by_id IS NULL))"
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
  end

  create_table "inbound_request_logs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.jsonb "meta", default: {}, null: false
    t.string "service", null: false
  end

  create_table "links", force: :cascade do |t|
    t.datetime "archived_at"
    t.datetime "created_at", null: false
    t.text "notes"
    t.string "secure_code"
    t.datetime "updated_at", null: false
    t.string "url"
    t.string "url_type"
    t.string "video_type"
  end

  create_table "maintenance_tasks_runs", force: :cascade do |t|
    t.text "arguments"
    t.text "backtrace"
    t.datetime "created_at", null: false
    t.string "cursor"
    t.datetime "ended_at", precision: nil
    t.string "error_class"
    t.string "error_message"
    t.string "job_id"
    t.integer "lock_version", default: 0, null: false
    t.text "metadata"
    t.datetime "started_at", precision: nil
    t.string "status", default: "enqueued", null: false
    t.string "task_name", null: false
    t.bigint "tick_count", default: 0, null: false
    t.bigint "tick_total"
    t.float "time_running", default: 0.0, null: false
    t.datetime "updated_at", null: false
    t.index ["task_name", "status", "created_at"], name: "index_maintenance_tasks_runs", order: { created_at: :desc }
  end

  create_table "organizations", force: :cascade do |t|
    t.string "address_1"
    t.string "address_2"
    t.datetime "archived_at"
    t.string "city"
    t.string "company_no"
    t.string "country"
    t.datetime "created_at", null: false
    t.string "email_address_1"
    t.string "email_address_2"
    t.string "fax_phone_number"
    t.string "name"
    t.text "notes"
    t.string "office_phone_number_1"
    t.string "office_phone_number_2"
    t.string "organization_type"
    t.string "state"
    t.datetime "updated_at", null: false
    t.string "website_url"
    t.string "zip_code"
  end

  create_table "pghero_query_stats", force: :cascade do |t|
    t.bigint "calls"
    t.datetime "captured_at", precision: nil
    t.text "database"
    t.text "query"
    t.bigint "query_hash"
    t.float "total_time"
    t.text "user"
    t.index ["database", "captured_at"], name: "index_pghero_query_stats_on_database_and_captured_at"
  end

  create_table "reports", force: :cascade do |t|
    t.datetime "archived_at"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.text "notes"
    t.text "sql", null: false
    t.datetime "updated_at", null: false
  end

  create_table "solid_cable_messages", force: :cascade do |t|
    t.binary "channel", null: false
    t.bigint "channel_hash", null: false
    t.datetime "created_at", null: false
    t.binary "payload", null: false
    t.index ["channel"], name: "index_solid_cable_messages_on_channel"
    t.index ["channel_hash"], name: "index_solid_cable_messages_on_channel_hash"
    t.index ["created_at"], name: "index_solid_cable_messages_on_created_at"
  end

  create_table "solid_cache_entries", force: :cascade do |t|
    t.integer "byte_size", null: false
    t.datetime "created_at", null: false
    t.binary "key", null: false
    t.bigint "key_hash", null: false
    t.binary "value", null: false
    t.index ["byte_size"], name: "index_solid_cache_entries_on_byte_size"
    t.index ["key_hash", "byte_size"], name: "index_solid_cache_entries_on_key_hash_and_byte_size"
    t.index ["key_hash"], name: "index_solid_cache_entries_on_key_hash", unique: true
  end

  create_table "storage_asset_service_prices", force: :cascade do |t|
    t.datetime "archived_at"
    t.datetime "created_at", null: false
    t.text "notes"
    t.decimal "price_per_gb_per_month"
    t.integer "priority"
    t.string "storage_asset_service"
    t.string "storage_asset_service_region"
    t.string "storage_asset_service_tier"
    t.datetime "updated_at", null: false
    t.integer "years_reserved"
  end

  create_table "storage_asset_sessions", force: :cascade do |t|
    t.datetime "archived_at"
    t.datetime "created_at", null: false
    t.datetime "expires_at"
    t.text "notes"
    t.string "setting", null: false
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["setting"], name: "index_storage_asset_sessions_on_setting", unique: true
  end

  create_table "storage_assets", force: :cascade do |t|
    t.string "access_tier"
    t.datetime "archived_at"
    t.datetime "asset_created_at"
    t.datetime "asset_updated_at"
    t.datetime "created_at", null: false
    t.string "full_path", null: false
    t.string "name", null: false
    t.text "notes"
    t.string "service", null: false
    t.bigint "size_bytes", null: false
    t.string "temporary_url"
    t.datetime "temporary_url_expires_at"
    t.datetime "updated_at", null: false
    t.index ["full_path"], name: "index_storage_assets_on_full_path", unique: true
  end

  create_table "system_group_system_roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "system_group_id"
    t.bigint "system_role_id"
    t.datetime "updated_at", null: false
    t.index ["system_group_id"], name: "index_system_group_system_roles_on_system_group_id"
    t.index ["system_role_id"], name: "index_system_group_system_roles_on_system_role_id"
  end

  create_table "system_group_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "system_group_id"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["system_group_id"], name: "index_system_group_users_on_system_group_id"
    t.index ["user_id"], name: "index_system_group_users_on_user_id"
  end

  create_table "system_groups", force: :cascade do |t|
    t.string "abbreviation"
    t.datetime "created_at", null: false
    t.string "description"
    t.string "name"
    t.text "notes"
    t.datetime "updated_at", null: false
  end

  create_table "system_permissions", force: :cascade do |t|
    t.string "abbreviation"
    t.datetime "created_at", null: false
    t.string "description"
    t.string "name"
    t.text "notes"
    t.string "operation"
    t.string "resource"
    t.datetime "updated_at", null: false
  end

  create_table "system_role_system_permissions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "system_permission_id"
    t.bigint "system_role_id"
    t.datetime "updated_at", null: false
    t.index ["system_permission_id"], name: "index_system_role_system_permissions_on_system_permission_id"
    t.index ["system_role_id"], name: "index_system_role_system_permissions_on_system_role_id"
  end

  create_table "system_roles", force: :cascade do |t|
    t.string "abbreviation"
    t.datetime "created_at", null: false
    t.string "description"
    t.string "name"
    t.text "notes"
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "archived_at"
    t.datetime "confirmation_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.inet "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "failed_attempts", default: 0, null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "last_sign_in_at"
    t.inet "last_sign_in_ip"
    t.datetime "locked_at"
    t.text "notes"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0, null: false
    t.string "unconfirmed_email"
    t.string "unlock_token"
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end
end
