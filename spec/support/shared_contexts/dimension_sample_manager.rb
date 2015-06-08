require './app/models/provider'

RSpec.shared_context 'dimension sample manager' do
  subject { described_class.new(options) }

  let(:relevant_providers) { Provider.where(cms_provider_id: provider_ids) }
  let(:selected_provider) do
    Provider.find_by_cms_provider_id(provider_ids)
  end
  let(:provider_1_id) { Provider.find_by_cms_provider_id('010103').id }
  let(:provider_2_id) { Provider.find_by_cms_provider_id('010087').id }
  let(:expected_data) do
    [
      [1.06, 'Hospital010103', provider_1_id, cms_rank, '010103'],
      [0.98, 'Hospital010087', provider_2_id, cms_rank, '010087'],
    ]
  end
  let(:provider_ids) do
    %w[
      010087
      010103
      010317
      010415
      010418
    ]
  end
  let(:dataset_value_column_name) do
    dataset_value_columns.fetch(dataset_id)
  end
  let(:dataset_best_value_method) do
    dataset_best_value_methods.fetch(dataset_id)
  end
  let(:dataset) { double('Dataset') }

  def create_relevant_providers
    provider_ids.each do |cms_provider_id|
      create(
        Provider,
        name: "Hospital#{cms_provider_id}",
        cms_provider_id: cms_provider_id,
      )
    end
  end

  def data
    subject.data(data_param.first, data_param.last)
  end

  def import
    VCR.use_cassette(cassette_name) { subject.import }
  end

  before do
    create_relevant_providers
    allow(Dataset).to receive(:new).with(measure_id: measure_id)
      .and_return(dataset)
    allow(dataset).to receive(:dataset_id).and_return(dataset_id)
    allow(dataset).to receive(:dataset_value_column_name)
      .and_return(dataset_value_column_name)
    allow(dataset).to receive(:dataset_best_value_method)
      .and_return(dataset_best_value_method)
  end

  shared_examples 'a DSM with national best performer value' do
    let(:national_best_performer_value) { 0.72 }

    it 'returns the best value' do
      import
      expect(subject.national_best_performer_value)
        .to eq(national_best_performer_value)
    end
  end

  shared_examples 'a dimension sample manager' do
    it 'pulls, persists, and returns data' do
      expect { import }.to change { data }
        .from([])
        .to expected_data
    end
  end
end
