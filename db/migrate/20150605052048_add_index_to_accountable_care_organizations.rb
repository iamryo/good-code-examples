class AddIndexToAccountableCareOrganizations < ActiveRecord::Migration
  def change
    add_index :accountable_care_organizations, :cms_aco_id, unique: true
  end
end
