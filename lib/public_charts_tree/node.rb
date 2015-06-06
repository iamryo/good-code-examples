# .
class PublicChartsTree
  # Delegates methods to a PublicChartsTree InternalNode, for use outside of
  # PublicChartsTree. Prevents us from unnecessarily exposing InternalNode
  # methods outside of PublicChartsTree.
  Node = Struct.new(:internal_node, :providers, :selected_provider) do
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
             :line_data,
             :value_description,
             :id_component,
             :id_components,
             to: :internal_node

    def initialize(internal_node, providers:, selected_provider:)
      super(internal_node, providers, selected_provider)
    end

    def breadcrumbs
      parent_breadcrumb + breadcrumb
    end

    def children
      internal_node.children.map do |child_internal_node|
        Node.new(
          child_internal_node,
          providers: providers,
          selected_provider: selected_provider,
        )
      end
    end

    def data
      {
        data_available: data_available?,
        bars: bars,
        title: title,
        lines: line_data,
      }
    end

    def data_available?
      return 'data_available' if bars.present?
      return 'data_unavailable' if bars.empty?
    end

    def bars
      value_dimension_manager.data(providers, selected_provider)
      .map do |value, provider_name, provider_id, cms_rank|
        {
          value: value,
          uri: "?provider_id=#{provider_id}",
          cms_rank: cms_rank,
          tooltip: {
            providerName: provider_name,
          },
        }
      end
    end

    def parent
      Node.new(
        internal_node.parent,
        providers: providers,
        selected_provider: selected_provider,
      )
    end

    private :breadcrumb,
            :parent_breadcrumb,
            :id_components
  end
end
