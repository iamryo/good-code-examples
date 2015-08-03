class DeleteOldPasswordsTable < ActiveRecord::Migration
  def change
    drop_table :old_passwords
  end
end
