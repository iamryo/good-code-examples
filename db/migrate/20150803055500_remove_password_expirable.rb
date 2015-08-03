class RemovePasswordExpirable < ActiveRecord::Migration
  def change
    remove_column :users, :password_changed_at
  end
end
