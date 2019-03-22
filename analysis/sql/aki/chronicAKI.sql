-- Chronic patients with AKI receiving rrt prior to ICU admission
SELECT
  DISTINCT treatment.patientunitstayid
FROM
  treatment
WHERE
  LOWER(treatment.treatmentstring) LIKE ANY ('{%rrt%,%dialysis%,%ultrafiltration%,%cavhd%,%cvvh%,%sled%}')
  AND 
  LOWER(treatment.treatmentstring) LIKE '%chronic%'
UNION  
  SELECT
  DISTINCT apacheapsvar.patientunitstayid
FROM
  eicu_crd_v2.apacheapsvar
WHERE
  apacheapsvar.dialysis = 1 -- chronic dialysis prior to hospital adm