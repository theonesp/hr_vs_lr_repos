  -- It tells whether the patient was mechanically ventilated any day of ICU admission.
  -- this query gets the data from respiratorycare (any invasive airway),
  -- respiratorycharting and treatment (either ETT/NiV) to tell whether
WITH
  t1 AS (
  SELECT
    DISTINCT patientunitstayid,
    respcarestatusoffset
  FROM
    eicu_crd_v2.respiratorycare
  WHERE
    respcarestatusoffset > -6*60 -- FROM minus 6 hours
    AND airwaytype IN ('Oral ETT',
      'Nasal ETT',
      'Tracheostomy') -- either invasive airway or NULL
    ),
  t2 AS (
  SELECT
    DISTINCT patientunitstayid,
    respchartoffset
  FROM
    eicu_crd_v2.respiratorycharting rc
  WHERE
    LOWER(respchartvalue) LIKE '%ventilator%'
    OR LOWER(respchartvalue) LIKE '%vent%'
    OR LOWER(respchartvalue) LIKE '%bipap%'
    OR LOWER(respchartvalue) LIKE '%840%'
    OR LOWER(respchartvalue) LIKE '%cpap%'
    OR LOWER(respchartvalue) LIKE '%drager%'
    OR LOWER(respchartvalue) LIKE 'mv%'
    OR LOWER(respchartvalue) LIKE '%servo%'
    OR LOWER(respchartvalue) LIKE '%peep%'
    AND respchartoffset > -6*60  -- FROM minus 6 hours
    ),
  t3 AS (
  SELECT
    DISTINCT patientunitstayid,
    treatmentoffset
  FROM
    eicu_crd_v2.treatment
  WHERE
    treatmentoffset > -6*60 -- FROM minus 6 hours
    AND treatmentstring IN ('pulmonary|ventilation and oxygenation|mechanical ventilation',
      'pulmonary|ventilation and oxygenation|tracheal suctioning',
      'pulmonary|ventilation and oxygenation|ventilator weaning',
      'pulmonary|ventilation and oxygenation|mechanical ventilation|assist controlled',
      'pulmonary|radiologic procedures / bronchoscopy|endotracheal tube',
      'pulmonary|ventilation and oxygenation|oxygen therapy (> 60%)',
      'pulmonary|ventilation and oxygenation|mechanical ventilation|tidal volume 6-10 ml/kg',
      'pulmonary|ventilation and oxygenation|mechanical ventilation|volume controlled',
      'surgery|pulmonary therapies|mechanical ventilation',
      'pulmonary|surgery / incision and drainage of thorax|tracheostomy',
      'pulmonary|ventilation and oxygenation|mechanical ventilation|synchronized intermittent',
      'pulmonary|surgery / incision and drainage of thorax|tracheostomy|performed during current admission for ventilatory support',
      'pulmonary|ventilation and oxygenation|ventilator weaning|active',
      'pulmonary|ventilation and oxygenation|mechanical ventilation|pressure controlled',
      'pulmonary|ventilation and oxygenation|mechanical ventilation|pressure support',
      'pulmonary|ventilation and oxygenation|ventilator weaning|slow',
      'surgery|pulmonary therapies|ventilator weaning',
      'surgery|pulmonary therapies|tracheal suctioning',
      'pulmonary|radiologic procedures / bronchoscopy|reintubation',
      'pulmonary|ventilation and oxygenation|lung recruitment maneuver',
      'pulmonary|surgery / incision and drainage of thorax|tracheostomy|planned',
      'surgery|pulmonary therapies|ventilator weaning|rapid',
      'pulmonary|ventilation and oxygenation|prone position',
      'pulmonary|surgery / incision and drainage of thorax|tracheostomy|conventional',
      'pulmonary|ventilation and oxygenation|mechanical ventilation|permissive hypercapnea',
      'surgery|pulmonary therapies|mechanical ventilation|synchronized intermittent',
      'pulmonary|medications|neuromuscular blocking agent',
      'surgery|pulmonary therapies|mechanical ventilation|assist controlled',
      'pulmonary|ventilation and oxygenation|mechanical ventilation|volume assured',
      'surgery|pulmonary therapies|mechanical ventilation|tidal volume 6-10 ml/kg',
      'surgery|pulmonary therapies|mechanical ventilation|pressure support') ),sq AS (
SELECT
  t1.patientunitstayid
FROM
  t1 UNION
SELECT
  t2.patientunitstayid
FROM
  t2 UNION
SELECT
  t3.patientunitstayid
FROM
  t3
  )
SELECT
  patient.patientunitstayid
,CASE WHEN
 patient.patientunitstayid = sq.patientunitstayid THEN 1 
 ELSE 0
END AS mech_vent_bin
  FROM
  eicu_crd_v2.patient
  LEFT JOIN
  sq
  USING
  (patientunitstayid)
