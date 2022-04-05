-- This query trims the icd code so there is one column per code in the list (they are separated by ',').
-- Then it selects patients with ICD code as Shock in the first 24 hours of admission.
WITH icd9_fixed AS(
SELECT 
  patientunitstayid,
  REPLACE(split_part(icd9code, ',', 1), '.', '') AS icd9_1 ,
  REPLACE(split_part(icd9code, ',', 2), '.', '') AS icd9_2 ,
  REPLACE(split_part(icd9code, ',', 3), '.', '') AS icd9_3 ,
  REPLACE(split_part(icd9code, ',', 4), '.', '') AS icd9_4 ,
  REPLACE(split_part(icd9code, ',', 5), '.', '') AS icd9_5 
FROM
  eicu_crd_v2.diagnosis
WHERE
  diagnosisoffset BETWEEN -6*60 AND 24*60
)
SELECT 
 patient.patientunitstayid
,MAX(CASE WHEN
    --icd9_1
       icd9_1 LIKE '%78551%'
    OR icd9_1 LIKE '%78550%'
    OR icd9_1 LIKE '%04082%'
    OR icd9_1 LIKE '%7855%'
    OR icd9_1 LIKE '%2765%'
     --icd9_2
    OR icd9_2 LIKE '%78551%'
    OR icd9_2 LIKE '%78550%'
    OR icd9_2 LIKE '%04082%'
    OR icd9_2 LIKE '%7855%'
    OR icd9_2 LIKE '%2765%'
     --icd9_3
    OR icd9_3 LIKE '%78551%'
    OR icd9_3 LIKE '%78550%'
    OR icd9_3 LIKE '%04082%'
    OR icd9_3 LIKE '%7855%'
    OR icd9_3 LIKE '%2765%'
     --icd9_4
    OR icd9_4 LIKE '%78551%'
    OR icd9_4 LIKE '%78550%'
    OR icd9_4 LIKE '%04082%'
    OR icd9_4 LIKE '%7855%'
    OR icd9_1 LIKE '%2765%'
     --icd9_4
    OR icd9_4 LIKE '%78551%'
    OR icd9_4 LIKE '%78550%'
    OR icd9_4 LIKE '%04082%'
    OR icd9_4 LIKE '%7855%'
    OR icd9_4 LIKE '%2765%' 
THEN  1 ELSE 0 END) AS icd_shock
FROM
  icd9_fixed
LEFT JOIN
  eicu_crd_v2.patient
  USING(patientunitstayid)
GROUP BY
  patient.patientunitstayid
