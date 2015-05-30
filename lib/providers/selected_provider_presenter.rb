require 'action_view/helpers/number_helper'

module Providers
  # Encapsulates the information needed to show data for the selected provider
  class SelectedProviderPresenter
    include ActionView::Helpers::NumberHelper
    attr_accessor :provider, :node

    delegate :socrata_provider_id, to: :provider

    def initialize(provider, node, teaser_node)
      @provider = provider
      @node = node
      @teaser_node = teaser_node
    end

    def value
      send("#{@teaser_node.type}_value")
    end

    def adjustment_factor
      value.to_f
    end

    def total_reimbursement_amount
      DSM.where(
        socrata_provider_id: socrata_provider_id,
        measure_id: 'fy_2013_total_reimbursement_amount',
      ).first.try(:value)
    end

    def financial_impact
      if total_reimbursement_amount
        return '$0' if adjustment_factor == 1.0
        number_to_currency(
          (1 - adjustment_factor) * -total_reimbursement_amount.to_i,
          precision: 0,
        )
      else
        'No data available'
      end
    end

    def cms_rank
      bars(node_data).try(:fetch, :cms_rank) || 'n/a'
    end

    private

    def bars(data)
      data.fetch(:bars, nil).first
    end

    def node_data
      @node.data
    end

    def teaser_node_data
      @teaser_node.data
    end

    def measure_value
      "#{bars(teaser_node_data).fetch(:value, 'n/a')} %"
    end

    def metric_module_value
      bars(teaser_node_data).try(:fetch, :value) || 'n/a'
    end
  end
end
