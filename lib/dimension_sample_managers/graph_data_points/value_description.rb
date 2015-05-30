require './lib/dimension_sample_managers/graph_data_points/measure'

module DimensionSampleManagers
  # .
  module GraphDataPoints
    # Returns the description of the measure's value to be displayed on teasers.
    ValueDescription = Struct.new(:id) do
      delegate :dataset_value_description, to: :dataset

      def self.call(*args)
        new(*args).call
      end

      def call
        dataset_value_description
      end

      private

      def dataset
        Dataset.new(measure_id: id)
      end
    end
  end
end
