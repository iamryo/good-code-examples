require './app/models/dimension_sample/measure'
require './lib/dimension_sample_importer'
require './lib/socrata/simple_soda_client_base'
require './lib/dataset'

module DimensionSampleManagers
  module GraphDataPoints
    # Interface to refresh data from Socrata and retrieve data
    # from the database.
    class Measure
      MODEL_CLASS = DimensionSample::Measure

      attr_reader :measure_id

      delegate :rename_hash, :measure_id_column_name, to: :column_manager
      delegate :dataset_id,
               :dataset_best_value_method,
               :dataset_value_column_name,
               to: :dataset

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

      def initialize(measure_id:)
        @measure_id = measure_id
      end

      def data(providers, selected_provider)
        DimensionSample::Measure.data(
          measure_id: measure_id,
          providers: providers,
          selected_provider: selected_provider,
        )
      end

      def import
        DimensionSampleImporter.call(
          dimension_samples: dimension_samples,
          model_attributes: base_options,
          model_class: MODEL_CLASS,
          rename_hash: rename_hash,
          value_column_name: dataset_value_column_name,
        )
      end

      def national_best_performer_value
        MODEL_CLASS.where(base_options)
          .public_send(dataset_best_value_method, :value)
      end

      private

      def dataset
        @dataset ||= Dataset.new(measure_id: measure_id)
      end

      def column_manager
        if hcahps_measure?
          HcahpsValueColumnManager
        else
          ValueColumnManager
        end
      end

      def dimension_samples
        if csv_measure?
          DimensionSampleManagers::Csv::DataImporter.call
        else
          ::Socrata::SimpleSodaClientBase.call(
            dataset_id: dataset_id,
            required_columns: required_columns,
            extra_query_options: {
              '$where' => "#{measure_id_column_name} = '#{measure_id}'",
            },
          )
        end
      end

      def required_columns
        [
          :provider_id,
          dataset_value_column_name,
        ]
      end

      def hcahps_measure?
        dataset_id == 'dgck-syfz'
      end

      def csv_measure?
        csv_measures.include?(measure_id)
      end

      def csv_measures
        [
          :corrected_fy_2015_readmissions_adjustment_factor,
          :fy_2013_total_reimbursement_amount,
        ]
      end

      def base_options
        { measure_id: measure_id }
      end
    end
  end
end

# Convenient alias for engineers on the command line
GDP_DSM = DimensionSampleManagers::GraphDataPoints::Measure
