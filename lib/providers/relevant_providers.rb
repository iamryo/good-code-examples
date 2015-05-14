RelevantProviders = Struct.new(:providers, :selected_provider_socrata_id) do
  def self.call(*args)
    new(*args).call
  end

  def call
    slice_providers
  end

  private

  def slice_providers
    providers.slice(starting_index, 70)
  end

  def selected_provider_index
    providers.find_index do |element|
      element.last == selected_provider_socrata_id
    end
  end

  def starting_index
    return 0 if !selected_provider_index || selected_provider_index - 35 < 0
    selected_provider_index - 35
  end
end
