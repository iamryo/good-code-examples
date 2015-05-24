require 'support/shared_contexts/dimension_sample_manager'
require 'dimension_sample_managers/graph_data_points/national_best_performer'

RSpec.describe DimensionSampleManagers::GraphDataPoints::
NationalBestPerformer do
  let(:measure_id) { :READM_30_AMI }
  let(:expected_data) do
    {
      value: '10.9',
      label: 'Best',
      bestValueMethod: dataset_best_value_method,
    }
  end
  let(:dsm) do
    instance_double(
      'DimensionSampleManagers::GraphDataPoints::Socrata::Measure',
    )
  end
  let(:dataset) { double('Dataset') }
  let(:dataset_best_value_method) { :minimum }
  subject { described_class.call(measure_id) }

  before do
    allow(DimensionSampleManagers::GraphDataPoints::Socrata::Measure)
      .to receive(:new).and_return(dsm)
    allow(dsm).to receive(:national_best_performer_value).and_return('10.9')
    allow(Dataset).to receive(:new).and_return(dataset)
    allow(dataset).to receive(:dataset_best_value_method)
      .and_return(dataset_best_value_method)
  end

  it 'retrieves the value and label data' do
    expect(subject).to eq(expected_data)
  end
end
