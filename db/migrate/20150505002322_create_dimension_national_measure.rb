class CreateDimensionNationalMeasure < ActiveRecord::Migration
  def change
    create_table :dimension_sample_national_measures do |t|
      t.string :dataset_id, null: false
      t.string :measure_id, null: false
      t.string :column_name, null: false
      t.string :value, null: false

      t.timestamps null: false
    end
  end
end
