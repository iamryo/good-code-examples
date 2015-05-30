class ChangeSocrataProviderIdToCmsProviderId < ActiveRecord::Migration
  def change
    [:dimension_sample_measures, :providers].each do |table|
      rename_column table, :socrata_provider_id, :cms_provider_id
    end
  end
end
