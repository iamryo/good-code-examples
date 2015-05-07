# == Schema Information
#
# Table name: dimension_sample_national_measures
#
#  id          :integer          not null, primary key
#  dataset_id  :string           not null
#  measure_id  :string           not null
#  column_name :string           not null
#  value       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require_relative '../dimension_sample'

module DimensionSample
  # National Average for measures.
  class NationalMeasure < ActiveRecord::Base
    validates :dataset_id, presence: true
    validates :measure_id, presence: true
    validates :column_name, presence: true
    validates :value, presence: true

    def self.data(measure_id)
      where(measure_id: measure_id).pluck(:value)
    end

    def self.create_or_update!(attributes)
      find_or_initialize_by(
        attributes.with_indifferent_access.slice(
          :measure_id,
        ),
      ).update_attributes!(attributes)
    end
  end
end

# Convenient alias for engineers on the command line
DSNM = DimensionSample::NationalMeasure
