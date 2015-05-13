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
      }

      attr_reader :id

      def initialize(id)
        @id = id
      end

      def data
        [
          {
            value: value,
            label: label,
          },
        ]
      end

      private

      def value
        ID_TO_AVG.fetch(id, nil)
      end

      def label
        'National Average'
      end
    end
  end
end
