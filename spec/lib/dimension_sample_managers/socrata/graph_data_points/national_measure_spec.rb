require 'active_record_no_rails_helper'
require 'support/shared_contexts/dimension_sample_manager'
require 'dimension_sample_managers/socrata/graph_data_points/national_measure'

RSpec.describe DimensionSampleManagers::Socrata::GraphDataPoints::
               NationalMeasure do
  include_context 'dimension sample manager'

  context 'for national measure dimension sample' do
    it_behaves_like 'a dimension sample manager' do
      let(:dataset_id) { 'seeb-g2s2' }
      let(:value_column_name) { :national_rate }
      let(:measure_id) { 'READM_30_AMI' }
      let(:options) do
        {
          dataset_id: dataset_id,
          value_column_name: value_column_name,
          measure_id: measure_id,
        }
      end
      let(:cassette_name) do
        'socrata_dimension_sample_managers_graph_data_points_national_measure'
      end
      let(:data_param) { measure_id }
      let(:expected_data) { ['17.8'] }

      def data
        subject.data(data_param)
      end
    end
  end
end
