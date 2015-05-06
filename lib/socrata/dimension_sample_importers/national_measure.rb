require 'socrata/simple_soda_client'
require 'active_support/core_ext/string/exclude'
require './app/models/dimension_sample/single_measure'

module Socrata
  # .
  module DimensionSampleRefreshers
    # Fetches Socrata data and creates or updates national measure dimension
    # samples in our database.
    NationalMeasure = Struct.new(:column_name, :dataset_id) do
      def self.call(column_name:, dataset_id:)
        new(column_name, dataset_id).call
      end

      def call
        processed_dimension_samples.each do |dimension_sample_attributes|
          DimensionSample::NationalMeasure
          .create_or_update!(dimension_sample_attributes)
        end
      end

      private

      def processed_dimension_samples
        available_dimension_samples.map do |dimension_sample|
          {
            column_name: column_name,
            dataset_id: dataset_id,
            value: dimension_sample.fetch(column_name),
          }
        end
      end

      def available_dimension_samples
        dimension_samples.select do |dimension_sample|
          dimension_sample.key?(column_name) and
          dimension_sample.fetch(column_name).exclude?('Not Available')
        end
      end

      def dimension_samples
        SimpleSodaClient.call(
          dataset_id: dataset_id,
          required_columns: required_columns,
        )
      end

      def required_columns
        [
          :dataset_id,
          column_name,
        ]
      end
    end
  end
end
