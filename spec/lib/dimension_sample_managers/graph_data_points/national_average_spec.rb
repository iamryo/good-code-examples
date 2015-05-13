require 'support/shared_contexts/dimension_sample_manager'
require 'dimension_sample_managers/graph_data_points/national_average'

RSpec.describe DimensionSampleManagers::GraphDataPoints::NationalAverage do
  let(:id) { 'mort_30_ami' }
  let(:id_to_avg) do
    {
      "#{id}" => '14.9',
    }
  end
  let(:expected_data) do
    [
      {
        value: '14.9',
        label: 'National Average',
      },
    ]
  end
  subject { described_class.new(id) }
  before do
    stub_const("#{described_class}::ID_TO_AVG", id_to_avg)
  end

  it 'retrieves the value and label data' do
    expect(subject.data).to eq(expected_data)
  end
end
