class DisableSessionLimitable < ActiveRecord::Migration
  def change
    remove_column :users, :unique_session_id
  end
end
