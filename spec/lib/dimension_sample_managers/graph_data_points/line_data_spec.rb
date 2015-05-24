require 'support/shared_contexts/dimension_sample_manager'
require 'dimension_sample_managers/graph_data_points/line_data'

RSpec.describe DimensionSampleManagers::GraphDataPoints::LineData do
  GRAPH_DATA_POINTS = DimensionSampleManagers::GraphDataPoints

  let(:national_best_performer_data)  do
    {
      value: '14.9',
      label: 'Best',
    }
  end
  let(:national_average_data) do
    {
      value: '14.9',
      label: 'National Average',
    }
  end
  let(:target_value_data) do
    {
      value: '1.0',
      label: 'Target',
    }
  end

  before do
    allow(GRAPH_DATA_POINTS::NationalAverage)
      .to receive(:call).with(id)
      .and_return(national_average_data)
    allow(GRAPH_DATA_POINTS::NationalBestPerformer)
      .to receive(:call).with(id)
      .and_return(national_best_performer_data)
  end

  subject { described_class.call(id) }

  context 'for a measure' do
    let(:id) { 'Foo' }
    let(:expected_line_data) do
      [
        national_average_data,
        national_best_performer_data,
      ]
    end
    it 'returns national average and best performer for a measure' do
      expect(subject).to eq(expected_line_data)
    end
  end

  context 'for a metric module' do
    let(:id) { :READMISSIONS_REDUCTION_PROGRAM }
    let(:expected_line_data) do
      [
        national_average_data,
        target_value_data,
      ]
    end
    it 'returns national average and target for the readmissions reduction' \
       'metric module' do
      expect(subject).to eq(expected_line_data)
    end
  end
end
