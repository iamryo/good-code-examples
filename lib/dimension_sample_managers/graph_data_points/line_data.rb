require 'dimension_sample_managers/graph_data_points/national_average'
require 'dimension_sample_managers/graph_data_points/national_best_performer'
# .
module DimensionSampleManagers
  # Returns line data for Readmissions Reduction metric module or measures.
  module GraphDataPoints
    LineData = Struct.new(:id) do
      def self.call(*args)
        new(*args).call
      end

      def call
        line_data
      end

      private

      def line_data
        data = readmissions_reduction_node? ? readmissions_data : measure_data
        data.compact
      end

      def readmissions_reduction_node?
        id == :READMISSIONS_REDUCTION_PROGRAM
      end

      def readmissions_data
        [
          national_average_data,
          readmissions_target_data,
        ]
      end

      def measure_data
        [
          national_average_data,
          national_best_performer_data,
        ]
      end

      def national_average_data
        DimensionSampleManagers::GraphDataPoints::NationalAverage
        .call(id)
      end

      def readmissions_target_data
        {
          value: '1.0', label: 'Target'
        }
      end

      def national_best_performer_data
        DimensionSampleManagers::GraphDataPoints::NationalBestPerformer
        .call(id)
      end
    end
  end
end
