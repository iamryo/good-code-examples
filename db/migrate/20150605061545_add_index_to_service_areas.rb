class AddIndexToServiceAreas < ActiveRecord::Migration
  def change
    add_index :service_areas, [:name, :abbreviation], unique: true
  end
end
