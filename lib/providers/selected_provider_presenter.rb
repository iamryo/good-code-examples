require 'action_view/helpers/number_helper'

module Providers
  # Encapsulates the information needed to show data for the selected provider
  class SelectedProviderPresenter
    include ActionView::Helpers::NumberHelper
    attr_accessor :provider, :node

    delegate :cms_provider_id, to: :provider

    def initialize(provider, node, embedded_node)
      @provider = provider
      @node = node
      @embedded_node = embedded_node
    end

    def value
      send("#{@embedded_node.type}_value")
    end

    def adjustment_factor
      value.to_f
    end

    def total_reimbursement_amount
      DSM.where(
        cms_provider_id: cms_provider_id,
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

    def embedded_node_data
      @embedded_node.data
    end

    def measure_value
      bars(embedded_node_data).try(:fetch, :value) || 'n/a'
    end

    def metric_module_value
      bars(embedded_node_data).try(:fetch, :value) || 'n/a'
    end
  end
end
