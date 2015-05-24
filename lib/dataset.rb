require 'active_support/inflector'

# Class to lookup associated datasets for measures and dataset attributes.
class Dataset
  include ActiveSupport::Inflector
  attr_reader :measure_id, :dataset_id

  MEASURE_ID_TO_DATASET = {
    '7xux-kdpw' => [
      :PSI_90_SAFETY,
      :READM_30_AMI,
      :READM_30_HF,
      :READM_30_PN,
      :READM_30_COPD,
      :READM_30_HIP_KNEE,
    ],

    '77hc-ibv8' => [
      :HAI_1_SIR,
      :HAI_2_SIR,
    ],

    'dgck-syfz' => [
      :H_COMP_1_A_P,
      :H_COMP_2_A_P,
      :H_COMP_3_A_P,
      :H_COMP_4_A_P,
      :H_COMP_5_A_P,
      :H_COMP_6_Y_P,
      :H_COMP_7_SA,
      :H_CLEAN_HSP_A_P,
      :H_QUIET_HSP_A_P,
      :H_HSP_RATING_9_10,
      :H_RECMND_DY,
    ],

    'fy_2015_readmissions_adjustment_factor' => [
      :corrected_fy_2015_readmissions_adjustment_factor,
    ],
  }
  DATASET_VALUE_COLUMN_NAME = {
    '7xux-kdpw' => :score,
    '77hc-ibv8' => :score,
    'dgck-syfz' => :hcahps_answer_percent,
    'fy_2015_readmissions_adjustment_factor' =>
      'corrected_fy_2015_readmissions_adjustment_factor',
  }
  DATASET_BEST_VALUE_METHOD = {
    'dgck-syfz' => :maximum,
    '99ue-w85f' => :maximum,
    'fy_2015_readmissions_adjustment_factor' => :maximum,
    '7xux-kdpw' => :minimum,
    '77hc-ibv8' => :minimum,
  }

  DATASET_VALUE_DESCRIPTION = {
    'dgck-syfz' => 'Positive Experience',
    '7xux-kdpw' => 'of patients were readmitted',
  }

  def initialize(measure_id:)
    @measure_id = measure_id
  end

  def method_missing(method)
    values_constant = "#{self.class}::#{method.upcase}".constantize
    values_constant.fetch(dataset_id)
  end

  def dataset_id
    MEASURE_ID_TO_DATASET.keys.find do |key|
      MEASURE_ID_TO_DATASET.fetch(key).include?(@measure_id)
    end
  end
end
