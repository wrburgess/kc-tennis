class NotificationSystem < ActiveRecord::Migration[8.0]
  def change
    create_table :notification_topics, force: :cascade do |t|
      t.string :name
      t.string :resource
      t.string :operation
      t.string :description
      t.text :note
      t.timestamps
    end

    create_table :notification_subscription, force: :cascade do |t|
      t.references :notifiable, polymorphic: true, null: false
      t.references :notification_topic
      t.string :notification_method
      t.text :note
      t.timestamps
    end

    create_table :notification_logs, force: :cascade do |t|
      t.references :notification_topic
      t.references :notification_susbscription
      t.timestamps
    end

    create_table :notification_channel, force: :cascade do |t|
      t.references :user
      t.string :name
      t.jsonb :configuration
      t.timestamps
    end
  end
end
