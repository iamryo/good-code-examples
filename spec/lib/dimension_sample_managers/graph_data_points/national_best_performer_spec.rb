require 'support/shared_contexts/dimension_sample_manager'
require 'dimension_sample_managers/graph_data_points/national_best_performer'

RSpec.describe DimensionSampleManagers::GraphDataPoints::
NationalBestPerformer do
  let(:id) { 'MORT_30_AMI' }
  let(:expected_data) do
    {
      value: '10.9',
      label: 'National Best Performer',
    }
  end
  let(:best_performer_manager) do
    instance_double(
      DimensionSampleManagers::GraphDataPoints::NationalBestPerformer,
    )
  end
  subject { described_class.new(id) }
  before do
    allow(DimensionSampleManagers::GraphDataPoints::NationalBestPerformer)
      .to receive(:new).with('MORT_30_AMI')
      .and_return(best_performer_manager)
    allow(best_performer_manager).to receive(:data).and_return(expected_data)
  end

  it 'retrieves the value and label data' do
    expect(subject.data).to eq(expected_data)
  end
end
