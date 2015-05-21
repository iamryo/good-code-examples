require 'support/shared_contexts/dimension_sample_manager'
require 'dimension_sample_managers/graph_data_points/lines'

RSpec.describe DimensionSampleManagers::GraphDataPoints::Lines do
  GRAPH_DATA_POINTS = DimensionSampleManagers::GraphDataPoints

  let(:id) { 'Foo' }
  let(:expected_line_data) do
    [
      {
        value: '14.9',
        label: 'National Average',
      },
    ]
  end

  let(:national_average_dsm) do
    instance_double("#{GRAPH_DATA_POINTS}::NationalAverage")
  end
  let(:national_best_performer) do
    instance_double("#{GRAPH_DATA_POINTS}::NationalBestPerformer")
  end

  before do
    allow(GRAPH_DATA_POINTS::NationalAverage)
      .to receive(:new).with(id).and_return(national_average_dsm)
    allow(GRAPH_DATA_POINTS::NationalBestPerformer)
      .to receive(:new).with(measure_id: id).and_return(national_best_performer)
  end

  subject { described_class.new(id: id, type: type) }

  context 'for a measure' do
    let(:type) { :measure }
    it 'returns national average and best performer' do
      expect(national_average_dsm).to receive(:data)
      expect(national_best_performer).to receive(:data)
      subject.data
    end
  end

  context 'for a metric module' do
    let(:type) { :metric_module }
    it 'returns national average and target for a metric module' do
      expect(national_average_dsm).to receive(:data)
      subject.data
    end
  end
end
