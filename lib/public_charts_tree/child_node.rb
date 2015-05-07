# .
class PublicChartsTree
  # A ChildNode instance represents any node below the root.
  ChildNode = Struct.new(:parent, :title) do
    attr_accessor :value_dimension_manager, :measure_dimension_manager

    delegate :breadcrumb,
             to: :parent,
             prefix: true

    def initialize(parent:, title:)
      super(parent, title)
    end

    def breadcrumb
      [Breadcrumb.new(title, id)]
    end

    def id_components
      parent.id_components + [id_component]
    end

    def id_component
      title.parameterize
    end

    def id
      id_components.join('/')
    end

    private

    Breadcrumb = Struct.new(:title, :id)
  end
end
