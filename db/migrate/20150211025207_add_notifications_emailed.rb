class AddNotificationsEmailed < ActiveRecord::Migration
  def change
    add_column :admin_users, :send_notifications, :boolean
  end
end
