require 'spec_helper'
require 'active_record_no_rails_helper'
require 'public_charts_tree'
require 'providers/selected_provider_presenter'

RSpec.describe Providers::SelectedProviderPresenter do
  subject { described_class.new(provider, node, teaser_node) }
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
      selected_provider: selected_provider,
    )
  end
  let(:teaser_node) do
    public_charts_tree.find_node(
      node_id,
      providers: selected_provider,
      selected_provider: selected_provider,
    )
  end
  let(:node_id) do
    'payment-programs/hospital-readmissions-reduction-program'
  end
  let(:value_dimension_sample_manager) do
    instance_double(DimensionSampleManagers::GraphDataPoints::
      Measure)
  end
  let(:value) { '.9832' }
  let(:dsm_data) do
    [
      [
        value,
        provider.name,
      ],
    ]
  end
  let(:bars) do
    {
      value: value,
      tooltip: {
        providerName: provider.name,
      },
    }
  end

  def selected_provider
    Provider.where(
      cms_provider_id: [provider].map(&:cms_provider_id),
    )
  end

  before do
    stub_const('VALUE_DIMENSION_SAMPLE_MANAGER', value_dimension_sample_manager)
    stub_const('PUBLIC_CHARTS_TREE', public_charts_tree)
    allow(value_dimension_sample_manager).to receive(:data)
      .with(selected_provider, selected_provider).and_return(dsm_data)
  end

  describe '#value' do
    it 'returns the value' do
      expect(subject.value).to eq(value)
    end
  end
end
