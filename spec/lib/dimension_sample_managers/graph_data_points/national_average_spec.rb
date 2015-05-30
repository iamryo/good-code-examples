require 'support/shared_contexts/dimension_sample_manager'
require 'dimension_sample_managers/graph_data_points/national_average'

RSpec.describe DimensionSampleManagers::GraphDataPoints::NationalAverage do
  let(:measure_id) { 'mort_30_ami' }
  let(:measure_id_to_avg) { { "#{measure_id}" => '14.9' } }
  let(:expected_data) do
    {
      value: '14.9',
      label: 'National Avg',
    }
  end
  subject { described_class.call(measure_id) }
  before do
    stub_const("#{described_class}::ID_TO_AVG", measure_id_to_avg)
  end

  it 'retrieves the value and label data' do
    expect(subject).to eq(expected_data)
  end
end
