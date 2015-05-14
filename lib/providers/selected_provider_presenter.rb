require 'action_view/helpers/number_helper'
module Providers
  # Encapsulates the information needed to show data for the selected provider
  class SelectedProviderPresenter
    include ActionView::Helpers::NumberHelper
    attr_accessor :provider, :node

    delegate :data, to: :node
    delegate :socrata_provider_id, to: :provider

    def initialize(provider, node)
      @provider = provider
      @node = node
    end

    def value
      data.fetch(:bars, nil).first.try(:fetch, :value) || 'n/a'
    end

    def adjustment_factor
      value.to_f
    end

    def total_reimbursement_amount
      DSPA.where(
        socrata_provider_id: socrata_provider_id,
        column_name: 'total_reimbursement_amount',
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
  end
end
