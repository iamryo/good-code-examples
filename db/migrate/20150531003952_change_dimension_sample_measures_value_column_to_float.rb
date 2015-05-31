class ChangeDimensionSampleMeasuresValueColumnToFloat < ActiveRecord::Migration
  def up
    change_column :dimension_sample_measures, :value, 'float USING CAST(value AS float)'
  end

  def down
    change_column :dimension_sample_measures, :value, 'varchar USING CAST(value AS varchar)'
  end
end
