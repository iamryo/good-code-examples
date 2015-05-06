# .
class PublicChartsTree
  # Delegates methods to a PublicChartsTree InternalNode, for use outside of
  # PublicChartsTree. Prevents us from unnecessarily exposing InternalNode
  # methods outside of PublicChartsTree.
  Node = Struct.new(:internal_node, :providers) do
    delegate :id,
             :search,
             :parent_is_root?,
             :title,
             :parent_id,
             :breadcrumb,
             :parent_breadcrumb,
             :parent_title,
             :type,
             :value_dimension_manager,
             :measure_dimension_manager,
             :id_component,
             :id_components,
             to: :internal_node

    def initialize(internal_node, providers:)
      super(internal_node, providers)
    end

    def breadcrumbs
      parent_breadcrumb + breadcrumb
    end

    def children
      internal_node.children.map do |child_internal_node|
        Node.new(child_internal_node, providers: providers)
      end
    end

    def data
      {
        bars: bars(providers),
        title: title,
        lines: lines,
      }
    end

    def bars(providers)
      return [] unless value_dimension_manager.present? # temporary until done
      value_dimension_manager.data(providers).map do |value, provider_name|
        {
          value: value,
          tooltip: {
            provider_name: provider_name,
          },
        }
      end
    end

    def lines
      return [] unless measure_dimension_manager.present? # temporary until done
      measure_dimension_manager.data(measure_id).map do |value|
        {
          label: 'National Average',
          value: value,
          measure_id: measure_id,
        }
      end
    end

    def parent
      Node.new(internal_node.parent, providers: providers)
    end

    private :breadcrumb,
            :parent_breadcrumb,
            :value_dimension_manager,
            :measure_dimension_manager,
            :id_components

    def measure_id
      return nil unless measure_dimension_manager.present?
      measure_dimension_manager.measure_id
    end
  end
end
