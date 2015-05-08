module Providers
  # Encapsulates the information needed to show data for the selected provider
  class SelectedProviderPresenter
    def initialize(provider, node)
      @provider = provider
      @node = node
    end

    def value
      data.fetch(:bars, nil).first.try(:fetch, :value) || 'n/a'
    end

    def data
      @node.data
    end
  end
end
