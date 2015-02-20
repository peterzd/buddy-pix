class CreateNotificationSettings < ActiveRecord::Migration
  def change
    create_table :notification_settings do |t|
      t.string :apple_device_token
      t.references :user, index: true
      t.text :apn_options
      t.text :email_options

      t.timestamps
    end

    add_index :notification_settings, :apple_device_token
  end
end
