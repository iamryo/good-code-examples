# Controller for autocomplete measures search
class MeasureSearchResultsController < ApplicationController
  def index
    ms = PUBLIC_CHARTS_TREE.find_node(
      'payment-programs',
      providers: provider_subset,
      selected_provider: selected_provider_relation,
    )
    term = params.fetch(:term)
    results = ms.search(term)
    render partial: 'metric_module',
           collection: results.children,
           locals: { term: term }
  end

  private

  def provider_subset
    Provider.first(5)
  end

  def selected_provider_relation
    Provider.where(
      socrata_provider_id: [current_user.selected_provider]
      .map(&:socrata_provider_id),
    )
  end
end
