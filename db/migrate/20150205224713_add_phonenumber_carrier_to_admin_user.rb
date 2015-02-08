class AddPhonenumberCarrierToAdminUser < ActiveRecord::Migration
  def change
    add_column :admin_users, :phone_number, :integer
    add_column :admin_users, :carrier, :string
    add_column :admin_users, :sms_gateway, :string
  end
end
