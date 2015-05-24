require 'active_record_no_rails_helper'
require 'support/shared_contexts/dimension_sample_manager'
require 'dimension_sample_managers/graph_data_points/socrata/provider_aggregate'

RSpec.describe DimensionSampleManagers::GraphDataPoints::Socrata::
               ProviderAggregate do
  include_context 'dimension sample manager'

  context 'for provider aggregate dimension samples' do
    let(:cassette_name) do
      'socrata_dimension_sample_managers_graph_data_points_provider_aggregate'
    end
    let(:cms_rank) { '2/2' }
    let(:dataset_id) { 'rrqw-56er' }
    let(:datasets_to_best_value_method) do
      {
        'rrqw-56er' => :minimum,
      }
    end
    let(:options) do
      {
        dataset_id: dataset_id,
        value_column_name: value_column_name,
      }
    end
    let(:data_param) { [relevant_providers, selected_provider] }

    before do
      stub_const(
        'Datasets::DATASET_TO_BEST_VALUE_METHOD',
        datasets_to_best_value_method,
      )
    end

    it_behaves_like 'a dimension sample manager'
    it_behaves_like 'a DSM with national best performer value'
  end
end
