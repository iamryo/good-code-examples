RelevantProviders = Struct.new(:providers, :selected_provider_cms_id) do
  MAX_DISPLAY_COUNT = 70
  MAX_DISPLAY_MID = MAX_DISPLAY_COUNT / 2
  CMS_RANK_INDEX = 3

  def self.call(*args)
    new(*args).call
  end

  def call
    new_providers_array
    slice_providers
  end

  private

  def new_providers_array
    providers.each do |provider|
      provider.slice!(CMS_RANK_INDEX) if provider.length == 5
      provider.insert(CMS_RANK_INDEX, cms_rank)
    end
  end

  def cms_rank
    "#{rank}/#{providers_count}"
  end

  def slice_providers
    new_providers_array.slice(starting_index, MAX_DISPLAY_COUNT)
  end

  def starting_index
    return 0 if !selected_provider_index ||
                selected_provider_index - MAX_DISPLAY_MID < 0

    selected_provider_index - MAX_DISPLAY_MID
  end

  def selected_provider_index
    @selected_provider_index ||= providers.find_index do |element|
      element.last == selected_provider_cms_id
    end
  end

  def rank
    selected_provider_index + 1 if selected_provider_index
  end

  def providers_count
    providers.count
  end
end
