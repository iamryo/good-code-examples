require 'dataset'

RSpec.describe Dataset do
  let(:measure_id_to_dataset) do
    {
      '7xux-kdpw' => [
        :READM_30_AMI,
      ],

      'dgck-syfz' => [
        :H_COMP_1_A_P,
      ],
    }
  end
  let(:dataset_value_column_name) do
    {
      '7xux-kdpw' => :score,
      'dgck-syfz' => :hcahps_answer_percent,
    }
  end
  let(:dataset_best_value_method) do
    {
      'dgck-syfz' => :maximum,
      '7xux-kdpw' => :minimum,
    }
  end
  let(:dataset_value_description) do
    {
      short_description: 'Readmission Rate',
      long_description: 'of patients were readmitted',
    }
  end
  let(:measure_id) { :READM_30_AMI }

  subject { described_class.new(measure_id: measure_id) }

  before do
    stub_const('::MEASURE_ID_TO_DATASET', measure_id_to_dataset)
    stub_const('::DATASET_VALUE_COLUMN_NAME', dataset_value_column_name)
    stub_const('::DATASET_BEST_VALUE_METHOD', dataset_best_value_method)
    stub_const('::DATASET_VALUE_DESCRIPTION', dataset_value_description)
  end

  it 'returns the dataset_id associated with the measure id' do
    expect(subject.dataset_id).to eq('7xux-kdpw')
  end

  it 'returns the dataset value column name' do
    expect(subject.dataset_value_column_name).to eq(:score)
  end

  it 'returns whether a higher or lower value score is better' do
    expect(subject.dataset_best_value_method).to eq(:minimum)
  end

  it 'returns the description for the dataset' do
    expect(subject.dataset_value_description)
      .to eq(dataset_value_description)
  end
end
