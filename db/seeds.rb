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

ServiceArea.create!([
  {
    name: 'Alabama',
    abbreviation: 'AL',
  },
  {
    name: 'Alaska',
    abbreviation: 'AK',
  },
  {
    name: 'Arizona',
    abbreviation: 'AZ',
  },
  {
    name: 'Arkansas',
    abbreviation: 'AR',
  },
  {
    name: 'California',
    abbreviation: 'CA',
  },
  {
    name: 'Colorado',
    abbreviation: 'CO',
  },
  {
    name: 'Connecticut',
    abbreviation: 'CT',
  },
  {
    name: 'Delaware',
    abbreviation: 'DE',
  },
  {
    name: 'Florida',
    abbreviation: 'FL',
  },
  {
    name: 'Georgia',
    abbreviation: 'GA',
  },
  {
    name: 'Hawaii',
    abbreviation: 'HI',
  },
  {
    name: 'Idaho',
    abbreviation: 'ID',
  },
  {
    name: 'Illinois',
    abbreviation: 'IL',
  },
  {
    name: 'Indiana',
    abbreviation: 'IN',
  },
  {
    name: 'Iowa',
    abbreviation: 'IA',
  },
  {
    name: 'Kansas',
    abbreviation: 'KS',
  },
  {
    name: 'Kentucky',
    abbreviation: 'KY',
  },
  {
    name: 'Louisiana',
    abbreviation: 'LA',
  },
  {
    name: 'Maine',
    abbreviation: 'ME',
  },
  {
    name: 'Maryland',
    abbreviation: 'MD',
  },
  {
    name: 'Massachusetts',
    abbreviation: 'MA',
  },
  {
    name: 'Michigan',
    abbreviation: 'MI',
  },
  {
    name: 'Minnesota',
    abbreviation: 'MN',
  },
  {
    name: 'Mississippi',
    abbreviation: 'MS',
  },
  {
    name: 'Missouri',
    abbreviation: 'MO',
  },
  {
    name: 'Montana',
    abbreviation: 'MT',
  },
  {
    name: 'Nebraska',
    abbreviation: 'NE',
  },
  {
    name: 'Nevada',
    abbreviation: 'NV',
  },
  {
    name: 'New Hampshire',
    abbreviation: 'NH',
  },
  {
    name: 'New Jersey',
    abbreviation: 'NJ',
  },
  {
    name: 'New Mexico',
    abbreviation: 'NM',
  },
  {
    name: 'New York',
    abbreviation: 'NY',
  },
  {
    name: 'North Carolina',
    abbreviation: 'NC',
  },
  {
    name: 'North Dakota',
    abbreviation: 'ND',
  },
  {
    name: 'Ohio',
    abbreviation: 'OH',
  },
  {
    name: 'Oklahoma',
    abbreviation: 'OK',
  },
  {
    name: 'Oregon',
    abbreviation: 'OR',
  },
  {
    name: 'Pennsylvania',
    abbreviation: 'PA',
  },
  {
    name: 'Rhode Island',
    abbreviation: 'RI',
  },
  {
    name: 'South Carolina',
    abbreviation: 'SC',
  },
  {
    name: 'South Dakota',
    abbreviation: 'SD',
  },
  {
    name: 'Tennessee',
    abbreviation: 'TN',
  },
  {
    name: 'Texas',
    abbreviation: 'TX',
  },
  {
    name: 'Utah',
    abbreviation: 'UT',
  },
  {
    name: 'Vermont',
    abbreviation: 'VT',
  },
  {
    name: 'Virginia',
    abbreviation: 'VA',
  },
  {
    name: 'Washington',
    abbreviation: 'WA',
  },
  {
    name: 'West Virginia',
    abbreviation: 'WV',
  },
  {
    name: 'Wisconsin',
    abbreviation: 'WI',
  },
  {
    name: 'Wyoming',
    abbreviation: 'WY',
  },
])
