require './app/models/dimension_sample/measure'
require './lib/datasets'
require './lib/socrata/dimension_sample_importer'
require './lib/socrata/simple_soda_client_base'

module DimensionSampleManagers
  module GraphDataPoints
    module Socrata
      # Satisfies the GraphDataPoint DimensionSampleManager interface to
      # retrieve and refresh data.
      class Measure
        MODEL_CLASS = DimensionSample::Measure

        # .
        module ValueColumnManager
          def self.rename_hash
            {}
          end

          def self.measure_id_column_name
            'measure_id'
          end
        end

        # .
        module HcahpsValueColumnManager
          def self.rename_hash
            { 'hcahps_measure_id' => 'measure_id' }
          end

          def self.measure_id_column_name
            'hcahps_measure_id'
          end
        end

        delegate :rename_hash, :measure_id_column_name, to: :column_manager

        def initialize(measure_id:)
          @measure_id = measure_id
        end

        def data(providers, selected_provider)
          DimensionSample::Measure.data(
            measure_id: @measure_id,
            providers: providers,
            selected_provider: selected_provider,
          )
        end

        def import
          ::Socrata::DimensionSampleImporter.call(
            dimension_samples: dimension_samples,
            model_attributes: base_options,
            model_class: MODEL_CLASS,
            rename_hash: rename_hash,
            value_column_name: value_column_name,
          )
        end

        def national_best_performer_value
          MODEL_CLASS.where(base_options).public_send(best_value_method, :value)
        end

        private

        def best_value_method
          Datasets.dataset_to_best_value_method(dataset_id)
        end

        def column_manager
          if hcahps_measure?
            HcahpsValueColumnManager
          else
            ValueColumnManager
          end
        end

        def dimension_samples
          ::Socrata::SimpleSodaClientBase.call(
            dataset_id: dataset_id,
            required_columns: required_columns,
            extra_query_options: {
              '$where' => "#{measure_id_column_name} = '#{@measure_id}'",
            },
          )
        end

        def required_columns
          [
            :provider_id,
            value_column_name,
          ]
        end

        def hcahps_measure?
          dataset_id == 'dgck-syfz'
        end

        def base_options
          { measure_id: @measure_id }
        end

        def dataset_id
          Datasets.measure_id_to_dataset(@measure_id)
        end

        def value_column_name
          Datasets.dataset_to_value_column_name(dataset_id)
        end
      end
    end
  end
end
