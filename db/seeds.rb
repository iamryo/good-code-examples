# This file should contain all the record creation needed to seed the database
# with its default values for development and acceptance environments.
# The data can then be loaded with the rake db:seed (or created alongside the
# db with db:reset).

hospital_system = HospitalSystem.create!(name: 'Mayo Health System')
providers = Provider.create!(
  [
    {
      name: 'MAYO CLINIC HOSPITAL',
      zip_code: '85054',
      hospital_type: 'Acute Care Hospitals',
      cms_provider_id: '030103',
      state: 'AZ',
      city: 'Nightingale',
    },
    {
      name: 'MAYO CLINIC',
      zip_code: '32224',
      hospital_type: 'Acute Care Hospitals',
      cms_provider_id: '100151',
      state: 'FL',
      city: 'JACKSONVILLE',
    },
  ],
) do |provider|
  provider.hospital_system = hospital_system
end

account = Account.create!(
  virtual_system: hospital_system,
  default_provider: providers.first,
)

%w[
  hospital-acquired-conditions
  hospital-readmissions-reduction-program
  hospital-consumer-assessment-of-healthcare-providers-and-systems
].each do |metric_module_id|
  PurchasedMetricModule.create!(
    account_id: account.id,
    metric_module_id: metric_module_id,
  )
end

AuthorizedDomain.create!(
  account_id: account.id,
  name: 'example.com',
)

User.create!(
  [
    {
      first_name: 'Florence',
      last_name: 'Nightingale',
      email: 'admin@example.com',
      password: 'smilearoundbecomingmighty',
      is_dabo_admin: true,
    },
    {
      first_name: 'Plebe',
      last_name: 'Johnson',
      email: 'plebe@example.com',
      password: 'smilearoundbecomingmighty',
      is_dabo_admin: false,
    },
  ],
) do |user|
  user.account = account
  user.skip_confirmation!
end
