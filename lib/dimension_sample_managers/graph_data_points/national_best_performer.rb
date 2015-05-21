require './lib/datasets'
require './app/models/dimension_sample/measure'

module DimensionSampleManagers
  # .
  module GraphDataPoints
    # Lookup table for DSM National Best performers
    NationalBestPerformer = Struct.new(:options) do
      def data
        {
          value: value,
          label: label,
        }
      end

      private

      def measure_id
        options.fetch(:measure_id)
      end

      def value
        DSM.where(measure_id: measure_id).send(best_value_method, :value)
      end

      def label
        'Best'
      end

      def dataset_id
        Datasets.measure_id_to_dataset(measure_id)
      end

      def best_value_method
        Datasets.dataset_to_best_value_method(dataset_id)
      end
    end
  end
end
