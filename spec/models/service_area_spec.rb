# == Schema Information
#
# Table name: service_areas
#
#  id           :integer          not null, primary key
#  name         :string           not null
#  abbreviation :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'active_record_no_rails_helper'
require './app/models/service_area'

RSpec.describe ServiceArea do
  describe 'columns' do
    it do
      is_expected.to have_db_column(:name).of_type(:string)
        .with_options(null: false)
    end
    it do
      is_expected.to have_db_column(:abbreviation).of_type(:string)
        .with_options(null: false)
    end
  end

  describe 'indexes' do
    it { is_expected.to have_db_index([:name, :abbreviation]).unique }
  end

  describe 'validations' do
    context 'no need to access the database' do
      subject { build_stubbed(described_class) }

      it { is_expected.to be_valid }

      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:abbreviation) }
    end

    context 'requires a record to be saved' do
      before { create(described_class) }
      it do
        is_expected.to validate_uniqueness_of(:name).scoped_to(:abbreviation)
      end
    end
  end
end
