class PublicChartsTree
  # Provides a degenerative case for recursive breadcrumb definition.
  module RootNode
    class << self
      def id_components
        []
      end

      def id
        ''
      end

      def breadcrumb
        []
      end

      def title
        'Metrics'
      end

      def value_dimension_manager
      end

      def line_data
      end

      def value_description
      end
    end
  end
end
