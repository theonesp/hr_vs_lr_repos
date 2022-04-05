-- Patients with ICD Code for AKI

SELECT
DISTINCT patientunitstayid
FROM
  eicu_crd_v2.diagnosis
WHERE
  LOWER(diagnosisstring )LIKE '%acute kidney%'
  OR lower(diagnosisstring) LIKE '%acute renal%'

