# .
module DimensionSampleManagers
  module GraphDataPoints
    # Lookup table for National Averages, regardless of chart/node type.
    class NationalAverage
      ID_TO_AVG = {
        MORT_30_AMI: '14.9',
        MORT_30_HF: '11.9',
        MORT_30_PN: '11.9',
        READM_30_AMI: '17.8',
        READM_30_HF: '22.7',
        READM_30_PN: '17.3',
        PSI_4_SURG_COMP: '118.52',
        PSI_6_IAT_PTX: '0.41',
        PSI_12_POSTOP_PULMEMB_DVT: '4.67',
        PSI_14_POSTOP_DEHIS: '1.91',
        PSI_15_ACC_LAC: '1.96',
        PSI_90_SAFETY: '0.88',
        COMP_HIP_KNEE: '3.3',
        READM_30_HIP_KNEE: '5.2',
        READM_30_HOSP_WIDE: '15.6',
        READM_30_COPD: '20.7',
        MORT_30_COPD: '7.8',
        READM_30_STK: '13.3',
        MORT_30_STK: '15.3',
        READMISSIONS_REDUCTION_PROGRAM: '0.9952',
        H_COMP_3_U_P: '23.0',
        H_COMP_3_SN_P: '9.0',
        H_COMP_1_A_P: '79.0',
        H_COMP_1_U_P: '17.0',
        H_COMP_1_SN_P: '4.0',
        H_COMP_2_A_P: '82.0',
        H_COMP_2_U_P: '14.0',
        H_COMP_2_SN_P: '4.0',
        H_COMP_3_A_P: '68.0',
        H_COMP_4_A_P: '71.0',
        H_COMP_4_U_P: '22.0',
        H_COMP_4_SN_P: '7.0',
        H_COMP_5_A_P: '65.0',
        H_COMP_5_U_P: '17.0',
        H_COMP_5_SN_P: '18.0',
        H_CLEAN_HSP_A_P: '74.0',
        H_CLEAN_HSP_U_P: '18.0',
        H_CLEAN_HSP_SN_P: '8.0',
        H_QUIET_HSP_A_P: '62.0',
        H_QUIET_HSP_U_P: '29.0',
        H_QUIET_HSP_SN_P: '9.0',
        H_COMP_6_Y_P: '86.0',
        H_COMP_6_N_P: '14.0',
        H_COMP_7_SA: '52.0',
        H_COMP_7_A: '43.0',
        H_COMP_7_D_SD: '5.0',
        H_HSP_RATING_9_10: '71.0',
        H_HSP_RATING_7_8: '21.0',
        H_HSP_RATING_0_6: '8.0',
        H_RECMND_DY: '71.0',
        H_RECMND_PY: '24.0',
        H_RECMND_DN: '5.0',
      }

      attr_reader :id

      def self.call(*args)
        new(*args).call
      end

      def initialize(id)
        @id = id
      end

      def call
        return unless value.present?
        {
          value: value,
          label: label,
        }
      end

      private

      def value
        ID_TO_AVG.fetch(id)
      end

      def label
        'National Avg'
      end
    end
  end
end
