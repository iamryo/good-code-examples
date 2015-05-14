require 'active_record_no_rails_helper'
require 'dimension_sample_managers/graph_data_points/csv/' \
        'provider_aggregate'
require 'support/shared_contexts/dimension_sample_manager'

RSpec.describe DimensionSampleManagers::GraphDataPoints::Csv::
               ProviderAggregate do
  include_context 'dimension sample manager'

  context 'for provider aggregate dimension samples' do
    let(:cassette_name) { '' } # temporary until Socrata/CSV separated
    let(:options) do
      {
        dataset_id: dataset_id,
        value_column_name: value_column_name,
      }
    end
    let(:provider_ids) do
      %w[
        010001
        010005
        010019
      ]
    end
    let(:provider_1_id) { Provider.find_by_socrata_provider_id('010001').id }
    let(:provider_2_id) { Provider.find_by_socrata_provider_id('010005').id }
    let(:expected_data) do
      [
        ['0.9968', 'Hospital010001', provider_1_id, '1/2', '010001'],
        ['0.9929', 'Hospital010005', provider_2_id, '1/2', '010005'],
      ]
    end
    let(:selected_provider_relation) do
      Provider.where(socrata_provider_id: provider_ids.first)
    end
    let(:data_param) { [relevant_providers, selected_provider_relation] }
    let(:dataset_id) { 'fy_2015_readmissions_adjustment_factor' }
    let(:value_column_name) do
      'corrected_fy_2015_readmissions_adjustment_factor'
    end
    let(:csv_file_path) do
      './spec/support/fixture_data/files/fy_2015_adjustment_factor_test.csv'
    end

    before { stub_const("#{described_class}::FILE_PATH", csv_file_path) }

    it_behaves_like 'a dimension sample manager'
  end
end
