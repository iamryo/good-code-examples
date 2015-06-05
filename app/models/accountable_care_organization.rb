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

# Represents an accountable care organization fetched from Socrata's API.
class AccountableCareOrganization < ActiveRecord::Base
  validates :cms_aco_id, uniqueness: true, presence: true
  validates :name, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true
end
