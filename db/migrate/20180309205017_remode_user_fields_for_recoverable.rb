class RemodeUserFieldsForRecoverable < ActiveRecord::Migration[5.1]
  def change
  	remove_column :users, :reset_password_sent_at
  	remove_column :users, :reset_password_token
  end
end
