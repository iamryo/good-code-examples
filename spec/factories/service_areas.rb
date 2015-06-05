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

FactoryGirl.define do
  factory :service_area do
    sequence(:name) { |n| "Service Area #{n}" }
    abbreviation 'MyString'
  end
end
