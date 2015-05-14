require 'dimension_sample_managers/graph_data_points/national_average'
require 'dimension_sample_managers/graph_data_points/national_best_performer'
# .
module DimensionSampleManagers
  module GraphDataPoints
    # Lookup table for Lines, regardless of chart/node type.
    class Lines
      attr_reader :id, :type

      def initialize(id:, type:)
        @id = id
        @type = type
      end

      def data
        [
          national_average_data,
          send("#{type}_data".to_sym),
        ]
      end

      private

      def national_average_data
        DimensionSampleManagers::GraphDataPoints::NationalAverage
          .new(id).data
      end

      def metric_module_data
        {
          value: '1.0', label: 'Target'
        }
      end

      def measure_data
        DimensionSampleManagers::GraphDataPoints::NationalBestPerformer
          .new(id).data
      end
    end
  end
end