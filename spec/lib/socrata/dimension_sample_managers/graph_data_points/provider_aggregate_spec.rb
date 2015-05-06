require 'active_record_no_rails_helper'
require 'socrata/dimension_sample_managers/graph_data_points/provider_aggregate'
require 'support/shared_contexts/socrata_value_dimension_sample_manager'

RSpec.describe Socrata::DimensionSampleManagers::GraphDataPoints::
               ProviderAggregate do
  include_context 'socrata value dimension sample manager'

  context 'for provider aggregate dimension samples' do
    let(:cassette_name) do
      'socrata_dimension_sample_managers_graph_data_points_provider_aggregate'
    end
    let(:dataset_id) { 'rrqw-56er' }
    let(:options) do
      {
        dataset_id: dataset_id,
        value_column_name: value_column_name,
      }
    end
    let(:data_param) { relevant_providers }

    it_behaves_like 'a dimension sample manager'
    it_behaves_like 'a DSM with national best performer value'
  end
end
