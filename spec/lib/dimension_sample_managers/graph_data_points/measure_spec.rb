require 'active_record_no_rails_helper'
require 'support/shared_contexts/dimension_sample_manager'
require 'dimension_sample_managers/graph_data_points/measure'

RSpec.describe DimensionSampleManagers::GraphDataPoints::Measure do
  include_context 'dimension sample manager'

  context 'for measure dimension samples' do
    let(:vcr_directory) do
      'DimensionSampleManagers_GraphDataPoints_Measure'
    end
    let(:expected_data) do
      [
        ['0.98', 'Hospital010087', provider_2_id, cms_rank, '010087'],
        ['1.06', 'Hospital010103', provider_1_id, cms_rank, '010103'],
      ]
    end
    let(:data_param) { [relevant_providers, selected_provider] }
    let(:cms_rank) { '1/2' }
    let(:dataset_best_value_methods) do
      {
        '7xux-kdpw' => :minimum,
        'dgck-syfz' => :maximum,
      }
    end
    let(:dataset_value_columns) do
      {
        '7xux-kdpw' => :score,
        'dgck-syfz' => :hcahps_answer_percent,
      }
    end

    let(:options) do
      {
        measure_id: measure_id,
      }
    end

    context 'lower is better' do
      let(:dataset_id) { '7xux-kdpw' }
      let(:measure_id) { :PSI_90_SAFETY }
      let(:cassette_name) { "#{vcr_directory}/lower_is_better" }
      it_behaves_like 'a dimension sample manager'
      it_behaves_like 'a DSM with national best performer value'
    end

    context 'higher is better' do
      let(:dataset_id) { 'dgck-syfz' }
      let(:measure_id) { :H_COMP_1_A_P }
      let(:cassette_name) { "#{vcr_directory}/higher_is_better" }
      it_behaves_like 'a DSM with national best performer value' do
        let(:national_best_performer_value) { '83' }
      end
    end
  end
end
