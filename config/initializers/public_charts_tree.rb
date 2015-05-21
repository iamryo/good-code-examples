PUBLIC_CHARTS_TREE = PublicChartsTree.new do
  measure_source 'Payment Programs' do
    if Flip.on? :hac
      metric_module 'Hospital-Acquired Conditions' do
        value DimensionSampleManagers::GraphDataPoints::Socrata::
          ProviderAggregate.new(
            value_column_name: :total_hac_score,
            dataset_id: 'yq43-i98g',
          )
        domain 'Patient Safety Indicator' do
          value DimensionSampleManagers::GraphDataPoints::Socrata::
          ProviderAggregate.new(
            value_column_name: :domain_1_score,
            dataset_id: 'yq43-i98g',
          )
          measures :PSI_90_SAFETY
        end
        domain 'Hospital Acquired Infection' do
          value DimensionSampleManagers::GraphDataPoints::Socrata::
          ProviderAggregate.new(
            value_column_name: :domain_2_score,
            dataset_id: 'yq43-i98g',
          )
          measures :HAI_1_SIR,
                   :HAI_2_SIR
        end
      end
    end
    metric_module 'Hospital Readmissions Reduction Program' do
      value DimensionSampleManagers::GraphDataPoints::Csv::
      ProviderAggregate.new(
        value_column_name: 'corrected_fy_2015_readmissions_adjustment_factor',
        dataset_id: 'fy_2015_readmissions_adjustment_factor',
      )
      line DimensionSampleManagers::GraphDataPoints::Lines.new(
        id: :READMISSIONS_REDUCTION_PROGRAM,
        type: :metric_module,
      )
      measures :READM_30_AMI,
               :READM_30_HF,
               :READM_30_PN,
               :READM_30_COPD,
               :READM_30_HIP_KNEE
    end
    if Flip.on? :hcahps
      metric_module 'Hospital Consumer Assessment of Healthcare Providers ' \
        'and Systems' do
        measures :H_COMP_1_A_P,
                 :H_COMP_2_A_P,
                 :H_COMP_3_A_P,
                 :H_COMP_4_A_P,
                 :H_COMP_5_A_P,
                 :H_COMP_6_Y_P,
                 :H_COMP_7_SA,
                 :H_CLEAN_HSP_A_P,
                 :H_QUIET_HSP_A_P,
                 :H_HSP_RATING_9_10,
                 :H_RECMND_DY
      end
    end
  end
end
