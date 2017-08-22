class AddDeviseRequiredMissingFields < ActiveRecord::Migration[5.1]
  #def change
  #end
  def up
    # All existing user accounts should be able to log in after this.\
    add_column :admin_users, :confirmation_token,   :string
    add_column :admin_users, :confirmed_at,         :datetime
    add_column :admin_users, :confirmation_sent_at, :datetime
    add_column :admin_users, :unconfirmed_email,    :string
    add_index  :admin_users, :confirmation_token, :unique => true
    AdminUser.all.update_all confirmed_at: DateTime.now
  end

  def down
    remove_index  :admin_users, :confirmation_token
    remove_column :admin_users, :unconfirmed_email
    remove_column :admin_users, :confirmation_sent_at
    remove_column :admin_users, :confirmed_at
    remove_column :admin_users, :confirmation_token
  end
end
