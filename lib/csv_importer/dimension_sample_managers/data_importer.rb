require 'csv'

module CsvImporter
  module DimensionSampleManagers
    # Creates an array of hashes from the CSV file data source
    class DataImporter
      def self.call(file_path:, dimension_samples:)
        CSV.foreach(file_path, headers: true) do |row|
          dimension_samples.push(row.to_hash)
        end
        dimension_samples
      end
    end
  end
end
