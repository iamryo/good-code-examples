require './app/models/dimension_sample/provider_aggregate'
require './lib/socrata/dimension_sample_importer'
require_relative '../data_importer'

module DimensionSampleManagers
  module Csv
    module GraphDataPoints
      # Satisfies the DimensionSampleManager interface to retrieve and refresh
      # data from a CSV file
      class ProviderAggregate
        MODEL_CLASS = DimensionSample::ProviderAggregate
        FILE_PATH = './lib/assets/files/fy_2015_adjustment_factor.csv'

        attr_reader :value_column_name, :dataset_id

        def initialize(value_column_name:, dataset_id:)
          @value_column_name = value_column_name
          @dataset_id = dataset_id
          @dimension_samples = {}
        end

        def data(providers, selected_provider)
          DimensionSample::ProviderAggregate.data(
            base_options.merge(
              column_name: value_column_name,
              providers: providers,
              selected_provider: selected_provider,
            ),
          )
        end

        def import
          ::Socrata::DimensionSampleImporter.call(
            dimension_samples: sanitized_dimension_samples,
            model_attributes: model_attributes,
            model_class: MODEL_CLASS,
            rename_hash: {},
            value_column_name: value_column_name,
          )
        end

        private

        def sanitized_dimension_samples
          dimension_samples.select do |dimension_sample|
            dimension_sample.fetch(value_column_name).present?
          end
        end

        def model_attributes
          base_options.merge(
            column_name: value_column_name,
          )
        end

        def base_options
          { dataset_id: dataset_id }
        end

        def dimension_samples
          DataImporter.call(file_path: FILE_PATH, dimension_samples: [])
        end
      end
    end
  end
end
