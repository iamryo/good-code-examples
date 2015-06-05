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

require './app/models/accountable_care_organization'

# Represents an ACO service area, typically a state.
class ServiceArea < ActiveRecord::Base
  validates :name, presence: true
  validates :abbreviation, presence: true

  validates :name, uniqueness: { scope: :abbreviation }
end
