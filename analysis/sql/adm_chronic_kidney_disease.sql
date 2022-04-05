-- This query identifies patients with history of CKD on admission.
SELECT 
patientunitstayid,
  MAX(CASE WHEN diagnosisstring ILIKE '%chronic kidney disease%' THEN 1
      ELSE 0
    END) AS adm_ckd
FROM 
eicu_crd_v2.diagnosis
GROUP BY 
patientunitstayid
