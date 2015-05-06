class ChangePhoneNumberToString < ActiveRecord::Migration
  def change
    remove_column :admin_users, :phone_number
    add_column :admin_users, :phone_number, :string
  end
end
