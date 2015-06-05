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

FactoryGirl.define do
  factory :accountable_care_organization do
    sequence(:cms_aco_id) { |n| n.to_s.rjust(6, '0') }
    sequence(:name) { |n| "ACO #{n}" }
    city 'SAN FRANCISCO'
    state 'CA'
    zip_code '90210'
  end
end
