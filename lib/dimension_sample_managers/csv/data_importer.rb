require 'csv'

module DimensionSampleManagers
  module Csv
    # Creates an array of hashes from the CSV file data source
    class DataImporter
      CSV_FILES = [
        './lib/assets/files/fy_2013_total_reimbursement_amount.csv',
        './lib/assets/files/fy_2015_adjustment_factor.csv',
      ]
      def self.call
        dimension_samples = []
        CSV_FILES.each do |csv_file|
          CSV.foreach(csv_file, headers: true) do |row|
            dimension_samples.push(row.to_hash)
          end
        end
        dimension_samples
      end
    end
  end
end
