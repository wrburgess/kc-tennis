class AddSomeModels < ActiveRecord::Migration[8.0]
  def change
    create_table :contacts, force: :cascade do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :prefix
      t.string :title
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :country
      t.string :direct_phone_number
      t.string :office_phone_number
      t.string :fax_phone_number
      t.string :email_address_1
      t.string :email_address_2
      t.text :notes
      t.datetime :archived_at
      t.timestamps
    end

    create_table :links, force: :cascade do |t|
      t.string :url_type
      t.string :url
      t.string :secure_code
      t.string :video_type
      t.text :notes
      t.datetime :archived_at
      t.timestamps
    end

    create_table :organizations, force: :cascade do |t|
      t.string :name
      t.string :organization_type
      t.string :company_no
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :country
      t.string :fax_phone_number
      t.string :office_phone_number_1
      t.string :office_phone_number_2
      t.string :email_address_1
      t.string :email_address_2
      t.string :website_url
      t.text :notes
      t.datetime :archived_at
      t.timestamps
    end

    create_table :reports, force: :cascade do |t|
      t.string :name, null: false
      t.text :description
      t.text :sql, null: false
      t.text :notes
      t.datetime :archived_at
      t.timestamps
    end

    create_table :storage_asset_service_prices, force: :cascade do |t|
      t.string :storage_asset_service
      t.string :storage_asset_service_tier
      t.string :storage_asset_service_region
      t.decimal :price_per_gb_per_month
      t.integer :years_reserved
      t.integer :priority
      t.text :notes
      t.datetime :archived_at
      t.timestamps
    end

    create_table :storage_asset_sessions, force: :cascade do |t|
      t.string :setting, null: false
      t.string :value
      t.datetime :expires_at
      t.text :notes
      t.datetime :archived_at
      t.timestamps
      t.index ["setting"], name: "index_storage_asset_sessions_on_setting", unique: true
    end

    create_table :storage_assets, force: :cascade do |t|
      t.string :service, null: false
      t.string :name, null: false
      t.string :full_path, null: false
      t.bigint :size_bytes, null: false
      t.string :access_tier
      t.string :temporary_url
      t.datetime :temporary_url_expires_at
      t.datetime :asset_created_at
      t.datetime :asset_updated_at
      t.text :notes
      t.datetime :archived_at
      t.timestamps
      t.index ["full_path"], name: "index_storage_assets_on_full_path", unique: true
    end
  end
end
