class CreateAccountableCareOrganizations < ActiveRecord::Migration
  def change
    create_table :accountable_care_organizations do |t|
      t.column :name, :string, null: false
      t.column :zip_code, :string, null: false
      t.column :state, :string, null: false
      t.column :city, :string, null: false
      t.column :cms_aco_id, :string, null: false

      t.timestamps null: false
    end
  end
end
