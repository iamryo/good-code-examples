# == Schema Information
#
# Table name: dimension_sample_national_measures
#
#  id          :integer          not null, primary key
#  dataset_id  :string
#  column_name :string
#  value       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :dimension_sample_national_measure,
          class: 'DimensionSample::NationalMeasure' do
    measure_id 'MORT_30_AMI'
    dataset_id 'seeb-g2s2'
    column_name 'national_rate'
    value '11.9'
  end
end
