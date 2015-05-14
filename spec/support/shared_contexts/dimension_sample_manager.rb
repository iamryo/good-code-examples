require './app/models/provider'

RSpec.shared_context 'dimension sample manager' do
  subject { described_class.new(options) }

  let(:relevant_providers) { Provider.where(socrata_provider_id: provider_ids) }
  let(:selected_provider) do
    Provider.where(socrata_provider_id: provider_ids.first)
  end
  let(:expected_data) do
    [
      ['1.06', 'Hospital010103', '010103'],
      ['0.98', 'Hospital010087', '010087'],
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
  let(:value_column_name) { :score }

  def create_relevant_providers
    provider_ids.each do |socrata_provider_id|
      create(
        Provider,
        name: "Hospital#{socrata_provider_id}",
        socrata_provider_id: socrata_provider_id,
      )
    end
  end

  def data
    subject.data(data_param.first, data_param.last)
  end

  def import
    VCR.use_cassette(cassette_name) { subject.import }
  end

  before { create_relevant_providers }

  shared_examples 'a DSM with national best performer value' do
    let(:national_best_performer_value) { '0.72' }

    it 'returns the lowest value' do
      import
      expect(subject.national_best_performer_value)
        .to eq national_best_performer_value
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
