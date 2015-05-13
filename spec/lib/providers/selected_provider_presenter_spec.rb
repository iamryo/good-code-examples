require 'spec_helper'
require 'active_record_no_rails_helper'
require 'public_charts_tree'
require 'providers/selected_provider_presenter'
require 'dimension_sample_managers/socrata/graph_data_points/provider_aggregate'

RSpec.describe Providers::SelectedProviderPresenter do
  subject { described_class.new(provider, node) }
  let(:provider) { create :provider }
  let(:public_charts_tree) do
    PublicChartsTree.new do
      measure_source 'Payment Programs' do
        metric_module 'Hospital Readmissions Reduction Program' do
          value VALUE_DIMENSION_SAMPLE_MANAGER
        end
      end
    end
  end
  let(:node) do
    public_charts_tree.find_node(
      node_id,
      providers: selected_provider,
    )
  end
  let(:node_id) do
    'payment-programs/hospital-readmissions-reduction-program'
  end
  let(:value_dimension_sample_manager) do
    instance_double(DimensionSampleManagers::Socrata::GraphDataPoints::
      ProviderAggregate)
  end
  let(:value) { '.9832' }
  let(:dspa_data) do
    [
      [
        value,
        provider.name,
      ],
    ]
  end

  def selected_provider
    Provider.where(
      socrata_provider_id: [provider].map(&:socrata_provider_id),
    )
  end

  before do
    stub_const('VALUE_DIMENSION_SAMPLE_MANAGER', value_dimension_sample_manager)
    stub_const('PUBLIC_CHARTS_TREE', public_charts_tree)
    allow(value_dimension_sample_manager).to receive(:data)
      .with(selected_provider).and_return(dspa_data)
  end

  describe '#value' do
    it 'returns the value' do
      expect(subject.value).to eq(value)
    end
  end
end
