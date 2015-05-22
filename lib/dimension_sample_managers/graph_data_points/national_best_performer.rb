require './lib/datasets'
require './app/models/dimension_sample/measure'
require './lib/dimension_sample_managers/graph_data_points/best_value'

module DimensionSampleManagers
  # .
  module GraphDataPoints
    # Lookup table for DSM National Best performers
    NationalBestPerformer = Struct.new(:options) do
      def data
        {
          value: value,
          label: label,
          bestValueMethod: best_value_method,
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

      def best_value_method
        DimensionSampleManagers::GraphDataPoints::BestValue.call(measure_id)
      end
    end
  end
end
