class AddUserAttributes < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :archived_at, :datetime, default: nil
  end
end