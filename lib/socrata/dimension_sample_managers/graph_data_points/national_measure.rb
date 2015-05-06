require './app/models/dimension_sample/national_measure'
require_relative '../../dimension_sample_importer'
require_relative '../../simple_soda_client'

# .
module Socrata
  module DimensionSampleManagers
    module GraphDataPoints
      # Satisfies the DimensionSampleManager interface to retrieve and refresh
      # data.
      class NationalMeasure
        MODEL_CLASS = DimensionSample::NationalMeasure
        attr_reader :value_column_name, :dataset_id, :measure_id

        def initialize(value_column_name:, dataset_id:, measure_id:)
          @value_column_name = value_column_name
          @dataset_id = dataset_id
          @measure_id = measure_id
        end

        def data(measure_id)
          DimensionSample::NationalMeasure.data(measure_id)
        end

        def import
          DimensionSampleImporter.call(
            dimension_samples: dimension_samples,
            model_attributes: model_attributes,
            model_class: MODEL_CLASS,
            rename_hash: {},
            value_column_name: value_column_name,
          )
        end

        private

        def model_attributes
          base_options.merge(
            column_name: value_column_name,
          )
        end

        def dimension_samples
          SimpleSodaClient.call(
            dataset_id: dataset_id,
            required_columns: required_columns,
          )
        end

        def required_columns
          [
            value_column_name,
            :measure_id,
          ]
        end

        def base_options
          { dataset_id: dataset_id }
        end
      end
    end
  end
end
