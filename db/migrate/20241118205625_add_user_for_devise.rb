class AddUserForDevise < ActiveRecord::Migration[8.0]
  def change
    create_table :users, force: :cascade do |t|
      ## Database authenticatable
      t.string   :email, default: "", null: false
      t.string   :encrypted_password, default: "", null: false

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at

      # Profile
      t.string   :first_name
      t.string   :last_name
      t.text     :notes

      # Meta
      t.timestamps null: false

      # Indexes
      t.index [ "email" ], name: "index_users_on_email", unique: true
      t.index [ "reset_password_token" ], name: "index_users_on_reset_password_token", unique: true
      t.index [ "confirmation_token" ], name: "index_users_on_confirmation_token", unique: true
      t.index [ "unlock_token" ], name: "index_users_on_unlock_token", unique: true
    end
  end
end
