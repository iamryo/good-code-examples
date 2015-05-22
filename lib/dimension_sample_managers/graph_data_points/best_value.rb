require './lib/datasets'

# .
module DimensionSampleManagers
  # Returns the best value method (minimum or maximum) for a given measure
  module GraphDataPoints
    BestValue = Struct.new(:measure_id) do
      def self.call(measure_id)
        new(measure_id).call
      end

      def call
        best_value_method
      end

      private

      def best_value_method
        Datasets.dataset_to_best_value_method(dataset_id)
      end

      def dataset_id
        Datasets.measure_id_to_dataset(measure_id)
      end
    end
  end
end
