# .
module DimensionSampleManagers
  module GraphDataPoints
    # Lookup table for National Best performers, regardless of chart/node type.
    class NationalBestPerformer
      attr_reader :id

      def initialize(id)
        @id = id
      end

      def data
        {
          value: value,
          label: label,
        }
      end

      private

      def value
        DSM.where(measure_id: id).minimum(:value)
      end

      def label
        'Best'
      end
    end
  end
end
