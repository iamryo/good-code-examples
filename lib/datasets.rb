# Reference class for dataset attributes: its measure_ids, best value, etc.
class Datasets
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
  }
  DATASET_TO_VALUE_COLUMN_NAME = {
    '7xux-kdpw' => :score,
    '77hc-ibv8' => :score,
    'dgck-syfz' => :hcahps_answer_percent,
  }
  DATASET_TO_BEST_VALUE_METHOD = {
    'dgck-syfz' => :maximum,
    '7xux-kdpw' => :minimum,
    '77hc-ibv8' => :minimum,
    '99ue-w85f' => :maximum,
  }

  def self.measure_id_to_dataset(measure_id)
    MEASURE_ID_TO_DATASET.keys.find do |key|
      MEASURE_ID_TO_DATASET.fetch(key).include?(measure_id)
    end
  end

  def self.dataset_to_value_column_name(dataset_id)
    DATASET_TO_VALUE_COLUMN_NAME.fetch(dataset_id, nil)
  end

  def self.dataset_to_best_value_method(dataset_id)
    DATASET_TO_BEST_VALUE_METHOD.fetch(dataset_id, nil)
  end

  def self.dataset_to_graph_lines(dataset_id)
    DATASET_TO_GRAPH_LINES.fetch(dataset_id, nil)
  end
end
