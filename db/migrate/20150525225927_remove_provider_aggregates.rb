class RemoveProviderAggregates < ActiveRecord::Migration
  def change
    drop_table :dimension_sample_provider_aggregates
  end
end
