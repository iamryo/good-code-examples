PUBLIC_CHARTS_TREE = PublicChartsTree.new do
  measure_source 'Payment Programs' do
    metric_module 'Hospital Readmissions Reduction Program' do
      value DimensionSampleManagers::GraphDataPoints::Measure.new(
        measure_id: :corrected_fy_2015_readmissions_adjustment_factor,
      )
      line DimensionSampleManagers::GraphDataPoints::LineData.call(
        :READMISSIONS_REDUCTION_PROGRAM,
      )
      value_description DimensionSampleManagers::GraphDataPoints::
      ValueDescription.call(:READMISSIONS_REDUCTION_PROGRAM)
      measures :READM_30_AMI,
               :READM_30_HF,
               :READM_30_PN,
               :READM_30_COPD,
               :READM_30_HIP_KNEE
    end
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
