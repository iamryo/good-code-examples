# == Schema Information
#
# Table name: accountable_care_organizations
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  zip_code   :string           not null
#  cms_aco_id :string           not null
#  state      :string           not null
#  city       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'active_record_no_rails_helper'
require './app/models/accountable_care_organization'

RSpec.describe AccountableCareOrganization do
  describe 'columns' do
    it do
      is_expected.to have_db_column(:name).of_type(:string)
        .with_options(null: false)
    end
    it do
      is_expected.to have_db_column(:zip_code).of_type(:string)
        .with_options(null: false)
    end
    it do
      is_expected.to have_db_column(:cms_aco_id).of_type(:string)
        .with_options(null: false)
    end
    it do
      is_expected.to have_db_column(:state).of_type(:string)
        .with_options(null: false)
    end
    it do
      is_expected.to have_db_column(:city).of_type(:string)
        .with_options(null: false)
    end
  end

  describe 'indexes' do
    it { is_expected.to have_db_index(:cms_aco_id).unique }
  end

  describe 'validations' do
    context 'no need to access the database' do
      subject { build_stubbed(described_class) }

      it { is_expected.to be_valid }

      it { is_expected.to validate_presence_of(:cms_aco_id) }
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:city) }
      it { is_expected.to validate_presence_of(:state) }
      it { is_expected.to validate_presence_of(:zip_code) }
    end

    context 'requires a record to be saved' do
      before { create(described_class) }
      it { is_expected.to validate_uniqueness_of(:cms_aco_id) }
    end
  end
end
