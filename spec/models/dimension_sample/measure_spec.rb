# == Schema Information
#
# Table name: dimension_sample_measures
#
#  id              :integer          not null, primary key
#  cms_provider_id :string           not null
#  measure_id      :string           not null
#  value           :float            not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'active_record_no_rails_helper'
require './app/models/dimension_sample/measure'

RSpec.describe DimensionSample::Measure do
  describe 'columns' do
    it do
      is_expected.to have_db_column(:cms_provider_id).of_type(:string)
        .with_options(null: false)
    end
    it do
      is_expected.to have_db_column(:measure_id).of_type(:string)
        .with_options(null: false)
    end
    it do
      is_expected.to have_db_column(:value).of_type(:float)
        .with_options(null: false)
    end
  end

  describe 'indexes' do
    it do
      is_expected.to have_db_index([:cms_provider_id, :measure_id]).unique
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:cms_provider_id) }
    it { is_expected.to validate_presence_of(:measure_id) }
    it { is_expected.to validate_presence_of(:value) }
  end

  describe 'data methods' do
    let(:dimension_sample_attributes) do
      {
        measure_id: measure_id,
        cms_provider_id: cms_provider_id,
        value: value,
      }
    end

    let(:cms_provider_id) { '010001' }
    let(:value) { 42.42424242 }
    let(:measure_id) { 'PSI_90_SAFETY' }
    let(:best_value_method) { :minimum }
    let(:dataset) { double('Dataset') }

    before do
      allow(Dataset).to receive(:new).with(measure_id: measure_id)
        .and_return(dataset)
      allow(dataset).to receive(:dataset_best_value_method)
        .and_return(best_value_method)
    end

    describe '.data' do
      let!(:relevant_provider_1) do
        create(Provider, cms_provider_id: relevant_provider_id_1)
      end
      let(:relevant_provider_id_1) { cms_provider_id }

      let!(:relevant_provider_2) do
        create(Provider, cms_provider_id: relevant_provider_id_2)
      end
      let(:relevant_provider_id_2) { '010005' }

      let(:irrelevant_provider_id) { '011998' }

      let!(:relevant_dimension_sample_1) do
        create_dimension_sample
      end
      let(:relevant_dimension_sample_1_value) { value }

      let!(:relevant_dimension_sample_2) do
        create_dimension_sample(
          cms_provider_id: relevant_provider_id_2,
          value: relevant_dimension_sample_2_value,
        )
      end
      let(:relevant_dimension_sample_2_value) { 12.0000000000 }

      let!(:dimension_sample_with_wrong_provider_id) do
        create_dimension_sample(cms_provider_id: irrelevant_provider_id)
      end
      let!(:dimension_sample_with_wrong_measure_id) do
        create_dimension_sample(measure_id: 'HAI_1_SIR')
      end

      let(:providers) { Provider.all }
      let(:selected_provider) do
        Provider.where(cms_provider_id: relevant_provider_1)
      end

      def create_dimension_sample(**custom_attributes)
        create(
          :dimension_sample_measure,
          dimension_sample_attributes.merge(custom_attributes),
        )
      end

      let(:data) do
        described_class.data(
          measure_id: measure_id,
          providers: providers,
          selected_provider: selected_provider,
        )
      end

      it 'gets the data' do
        expect(data).to eq [
          [
            relevant_dimension_sample_2_value,
            relevant_provider_2.name,
            relevant_provider_2.id,
            '/2',
            relevant_provider_2.cms_provider_id,
          ],
          [
            relevant_dimension_sample_1_value,
            relevant_provider_1.name,
            relevant_provider_1.id,
            '/2',
            relevant_provider_1.cms_provider_id,
          ],
        ]
      end
    end

    describe '.create_or_update!' do
      let(:new_attributes) { dimension_sample_attributes.merge(new_attribute) }

      let!(:existing_dimension_sample) do
        create(
          :dimension_sample_measure,
          dimension_sample_attributes,
        )
      end
      let(:most_recent_attributes) do
        described_class.last.attributes.symbolize_keys
      end

      def create_or_update!
        described_class.create_or_update!(new_attributes)
      end

      context 'attributes match an existing record' do
        let(:new_attribute) { { value: 10.8274 } }

        it 'updates the existing record' do
          expect { create_or_update! }
            .to change { existing_dimension_sample.reload.attributes }
            .to hash_including(new_attributes.stringify_keys)
        end
      end

      context 'with a different measure_id' do
        let(:new_attribute) { { measure_id: 'HAI_1_SIR' } }

        it 'makes a new record' do
          expect { create_or_update! }.to change(described_class, :count).by(1)
          expect(most_recent_attributes).to include new_attributes
        end
      end

      context 'with a different cms_provider_id' do
        let(:new_attribute) { { cms_provider_id: '0000002' } }

        it 'makes a new record' do
          expect { create_or_update! }.to change(described_class, :count).by(1)
          expect(most_recent_attributes).to include new_attributes
        end
      end
    end

    describe '.sort_providers' do
      let(:provider_with_lower_value) do
        [
          12.0000000000,
          'My Provider 2',
          2,
          '010005',
        ]
      end
      let(:provider_with_higher_value) do
        [
          42.42424242,
          'My Provider 1',
          1,
          '010001',
        ]
      end
      let(:provider_data_array) do
        [
          provider_with_lower_value,
          provider_with_higher_value,
        ]
      end

      let(:sort_providers) do
        described_class.sort_providers(provider_data_array, measure_id)
      end

      context 'measures where higher values are better' do
        let(:measure_id) { 'HAI_1_SIR' }
        let(:best_value_method) { :maximum }
        let(:expected_data) do
          [
            provider_with_higher_value,
            provider_with_lower_value,
          ]
        end
        it 'sorts the data by descending measure values' do
          expect(sort_providers).to eq(expected_data)
        end
      end

      context 'measure where lower values better' do
        let(:measure_id) { 'PSI_90_SAFETY' }
        let(:best_value_method) { :minimum }
        let(:expected_data) do
          [
            provider_with_lower_value,
            provider_with_higher_value,
          ]
        end
        it 'sorts the data by descending measure values' do
          expect(sort_providers).to eq(expected_data)
        end
      end
    end

    describe '.best_value_method' do
      let(:best_value) { described_class.best_value_method(measure_id) }

      it 'returns the best value method' do
        expect(best_value).to eq :minimum
      end
    end
  end
end
