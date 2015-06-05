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
end
