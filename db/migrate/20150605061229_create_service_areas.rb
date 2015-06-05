class CreateServiceAreas < ActiveRecord::Migration
  def change
    create_table :service_areas do |t|
      t.string :name, null: false
      t.string :abbreviation, null: false

      t.timestamps null: false
    end
  end
end
