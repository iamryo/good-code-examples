require './app/models/dimension_sample/provider_aggregate'
require './lib/socrata/dimension_sample_importer'
require './lib/socrata/simple_soda_client'

# .
module DimensionSampleManagers
  module Socrata
    module GraphDataPoints
      # Satisfies the DimensionSampleManager interface to retrieve and refresh
      # data.
      class ProviderAggregate
        MODEL_CLASS = DimensionSample::ProviderAggregate
        attr_reader :value_column_name, :dataset_id

        def initialize(value_column_name:, dataset_id:)
          @value_column_name = value_column_name
          @dataset_id = dataset_id
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
            dimension_samples: dimension_samples,
            model_attributes: model_attributes,
            model_class: MODEL_CLASS,
            rename_hash: {},
            value_column_name: value_column_name,
          )
        end

        def subtitle
        end

        def national_best_performer_value
          MODEL_CLASS.where(model_attributes).minimum(:value)
        end

        private

        def model_attributes
          base_options.merge(
            column_name: value_column_name,
          )
        end

        def dimension_samples
          ::Socrata::SimpleSodaClient.call(
            dataset_id: dataset_id,
            required_columns: required_columns,
          )
        end

        def required_columns
          [
            :provider_id,
            value_column_name,
          ]
        end

        def base_options
          { dataset_id: dataset_id }
        end
      end
    end
  end
end
