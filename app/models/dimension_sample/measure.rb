# == Schema Information
#
# Table name: dimension_sample_measures
#
#  id              :integer          not null, primary key
#  cms_provider_id :string           not null
#  measure_id      :string           not null
#  value           :float            not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require './app/models/provider'
require './lib/providers/relevant_providers'
require './lib/dataset'

require_relative '../dimension_sample'

module DimensionSample
  # Corresponds to a dataset like 7xux-kdpw, which has multiple rows per
  # provider.
  class Measure < ActiveRecord::Base
    validates :cms_provider_id, presence: true
    validates :measure_id, presence: true
    validates :value, presence: true

    def self.data(measure_id:, providers:, selected_provider:)
      matching_samples = where(measure_id: measure_id)
      relevant_providers = relevant_providers(matching_samples, providers)

      RelevantProviders.call(
        sort_providers(relevant_providers, measure_id),
        selected_provider.cms_provider_id,
      )
    end

    def self.relevant_providers(matching_samples, providers)
      providers.joins(<<-SQL)
        LEFT OUTER JOIN dimension_sample_measures
        ON dimension_sample_measures.cms_provider_id =
        providers.cms_provider_id
      SQL
        .merge(matching_samples)
        .pluck(:value, :name, :id, :cms_provider_id)
        .sort_by(&:first)
    end

    def self.create_or_update!(attributes)
      find_or_initialize_by(
        attributes.with_indifferent_access.slice(
          :cms_provider_id,
          :measure_id,
        ),
      ).update_attributes!(attributes)
    end

    def self.sort_providers(provider_data_array, measure_id)
      if best_value_method(measure_id) == :maximum
        provider_data_array.reverse
      else
        provider_data_array
      end
    end

    def self.best_value_method(measure_id)
      Dataset.new(measure_id: measure_id).dataset_best_value_method
    end
  end
end

# Convenient alias for engineers on the command line
DSM = DimensionSample::Measure
