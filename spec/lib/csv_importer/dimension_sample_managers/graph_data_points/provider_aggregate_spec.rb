require 'active_record_no_rails_helper'
require 'csv_importer/dimension_sample_managers/graph_data_points/' \
        'provider_aggregate'
require 'support/shared_contexts/socrata_value_dimension_sample_manager'

RSpec.describe CsvImporter::DimensionSampleManagers::GraphDataPoints::
               ProviderAggregate do
  include_context 'socrata value dimension sample manager'

  context 'for provider aggregate dimension samples' do
    let(:cassette_name) do
      'csv_importer_dimension_sample_managers_graph_data_points_' \
      'provider_aggregate'
    end
    let(:options) do
      {
        dataset_id: dataset_id,
        value_column_name: value_column_name,
      }
    end
    let(:provider_ids) do
      %w[
        10001
        10005
      ]
    end
    let(:expected_data) do
      [
        ['0.9968', 'Hospital10001'],
        ['0.9929', 'Hospital10005'],
      ]
    end
    let(:data_param) { relevant_providers }
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
