require './lib/dimension_sample_managers/graph_data_points/socrata/measure'

module DimensionSampleManagers
  # .
  module GraphDataPoints
    # Returns the 'best' measure value according its dataset.
    NationalBestPerformer = Struct.new(:id) do
      delegate :dataset_best_value_method, to: :dataset

      def self.call(*args)
        new(*args).call
      end

      def call
        return unless value.present?
        {
          value: value,
          label: label,
          bestValueMethod: dataset_best_value_method,
        }
      end

      private

      def value
        DimensionSampleManagers::GraphDataPoints::Socrata::Measure
        .new(measure_id: id)
        .national_best_performer_value
      end

      def dataset
        Dataset.new(measure_id: id)
      end

      def label
        'Best'
      end
    end
  end
end
