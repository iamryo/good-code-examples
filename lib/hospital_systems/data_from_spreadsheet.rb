require 'roo'
require 'roo-xls'

module HospitalSystems
  # Read the Excel file with information about systems and hospitals.
  # This class iterates all the systems and their associated hospitals.
  class DataFromSpreadsheet
    FILEPATH = 'lib/assets/files/hospital_systems.xls'
    HEADERS = {
      cms_provider_id: 'Provider Number',
      system_name: 'System Name',
    }

    def self.call(*args)
      new(*args).call
    end

    def call
      data_rows.map do |row|
        {
          system_name: row.fetch(:system_name),
          cms_provider_id: normalized_provider_id(
            row.fetch(:cms_provider_id),
          ),
        }
      end
    end

    private

    def file_data
      Roo::Spreadsheet.open(FILEPATH, file_warning: :ignore)
    end

    def data_rows
      all_rows_lazy.reject { |row| header?(row) }
    end

    def all_rows_lazy
      file_data.parse(HEADERS).lazy
    end

    def header?(row)
      row.fetch(:system_name) == 'System Name'
    end

    def normalized_provider_id(cms_provider_id)
      provider_id_to_string(cms_provider_id).rjust(6, '0')
    end

    def provider_id_to_string(cms_provider_id)
      if cms_provider_id.is_a?(Numeric)
        cms_provider_id.to_i.to_s
      else
        cms_provider_id
      end
    end
  end
end
