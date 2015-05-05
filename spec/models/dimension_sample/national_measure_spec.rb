# == Schema Information
#
# Table name: dimension_sample_national_measures
#
#  id          :integer          not null, primary key
#  dataset_id  :string           not null
#  measure_id  :string           not null
#  column_name :string           not null
#  value       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'active_record_no_rails_helper'
require './app/models/dimension_sample/national_measure'

RSpec.describe DimensionSample::NationalMeasure do
  subject { build_stubbed :dimension_sample_national_measure }

  describe 'columns' do
    it do
      is_expected.to have_db_column(:dataset_id).of_type(:string)
        .with_options(null: false)
    end

    it do
      is_expected.to have_db_column(:measure_id).of_type(:string)
        .with_options(null: false)
    end

    it do
      is_expected.to have_db_column(:column_name).of_type(:string)
        .with_options(null: false)
    end

    it do
      is_expected.to have_db_column(:value).of_type(:string)
        .with_options(null: false)
    end
  end

  describe 'validations' do
    it { is_expected.to be_valid }
    it { is_expected.to validate_presence_of(:dataset_id) }
    it { is_expected.to validate_presence_of(:measure_id) }
    it { is_expected.to validate_presence_of(:column_name) }
    it { is_expected.to validate_presence_of(:value) }
  end

  describe 'data methods' do
    let(:dimension_sample_attributes) do
      {
        column_name: column_name,
        dataset_id: dataset_id,
        measure_id: measure_id,
        value: value,
      }
    end
    let(:column_name) { 'national_rate' }
    let(:dataset_id) { 'seeb-g2s2' }
    let(:measure_id) { 'MORT_30_HF' }
    let(:value) { '9.1' }
    let(:new_attributes) do
      dimension_sample_attributes.merge(new_attribute)
    end
    let!(:existing_dimension_sample) do
      create(
        :dimension_sample_national_measure,
        dimension_sample_attributes,
      )
    end
    let(:most_recent_attributes) do
      described_class.last.attributes.symbolize_keys
    end

    describe '.data' do
      let!(:relevant_measure_id) { 'READM_30_HF' }
      let!(:relevant_measure_value) { '27' }
      let!(:relevant_national_measure) do
        create(
          :dimension_sample_national_measure,
          measure_id: relevant_measure_id,
          value: relevant_measure_value,
        )
      end
      let!(:wrong_measure_id) { 'PSI_4_SURG_COMP' }
      let!(:wrong_measure_value) { '16' }
      let!(:wrong_national_measure) do
        create(
          :dimension_sample_national_measure,
          measure_id: wrong_measure_id,
          value: wrong_measure_value,
        )
      end
      let(:data) { described_class.data(measure_id: relevant_measure_id) }

      it 'gets the data' do
        expect(data).to eq [relevant_measure_value]
      end
    end

    describe '.create_or_update!' do
      def create_or_update!
        described_class.create_or_update!(new_attributes)
      end

      context 'attributes match an existing record' do
        let(:new_attribute) { { value: '10.8274' } }

        it 'updates the existing record' do
          expect { create_or_update! }
            .to change { existing_dimension_sample.reload.attributes }
            .to hash_including(new_attributes.stringify_keys)
        end
      end

      context 'with a different dataset_id' do
        let(:new_attribute) { { dataset_id: 'blah-blah' } }

        it 'makes a new record' do
          expect { create_or_update! }.to change(described_class, :count).by(1)
          expect(most_recent_attributes).to include new_attributes
        end
      end
    end
  end
end
