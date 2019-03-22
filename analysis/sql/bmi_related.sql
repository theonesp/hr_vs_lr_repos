-- this query extracts converts and normalizes patients weight, height and BMI
WITH
  weight AS (
  WITH
    t1 AS (
    SELECT
      patientunitstayid
      -- all of the below weights are measured in kg
      ,
      nursingchartvalue::NUMERIC AS weight
    FROM
      eicu_crd_v2.nursecharting
    WHERE
      nursingchartcelltypecat = 'Other Vital Signs and Infusions'
      AND nursingchartcelltypevallabel IN ( 'Admission Weight','Admit weight','WEIGHT in Kg' )
      -- ensure that nursingchartvalue is numeric
      AND nursingchartvalue ~ '^([0-9]+\\.?[0-9]*|\\.[0-9]+)$'
      AND NURSINGCHARTOFFSET >= -60
      AND NURSINGCHARTOFFSET < 60*24 )
    -- weight from intake/output table
    ,
    t2 AS (
    SELECT
      patientunitstayid,
      CASE
        WHEN CELLPATH = 'flowsheet|Flowsheet Cell Labels|I&O|Weight|Bodyweight (kg)' THEN CELLVALUENUMERIC
        ELSE CELLVALUENUMERIC*0.453592
      END AS weight
    FROM
      eicu_crd_v2.intakeoutput
      -- there are ~300 extra (lb) measurements, so we include both
      -- worth considering that this biases the median of all three tables towards these values..
    WHERE
      CELLPATH IN ( 'flowsheet|Flowsheet Cell Labels|I&O|Weight|Bodyweight (kg)','flowsheet|Flowsheet Cell Labels|I&O|Weight|Bodyweight (lb)' )
      AND INTAKEOUTPUTOFFSET >= -60
      AND INTAKEOUTPUTOFFSET < 60*24 )
    -- weight from infusiondrug
    ,
    t3 AS (
    SELECT
      patientunitstayid,
      PATIENTWEIGHT::NUMERIC AS weight
    FROM
      eicu_crd_v2.infusiondrug
    WHERE
      PATIENTWEIGHT IS NOT NULL
      AND PATIENTWEIGHT != ''
      AND INFUSIONOFFSET >= -60
      AND INFUSIONOFFSET < 60*24 ),
    unioned AS (
    SELECT
      patientunitstayid,
      admissionweight AS weight
    FROM
      eicu_crd_v2.patient pt
    UNION ALL
    SELECT
      patientunitstayid,
      weight
    FROM
      t1
    UNION ALL
    SELECT
      patientunitstayid,
      weight
    FROM
      t2
    UNION ALL
    SELECT
      patientunitstayid,
      weight
    FROM
      t3 )
  SELECT
    patientunitstayid,
    ROUND(AVG(weight), 2) AS weight_avg
  FROM
    unioned
  WHERE
    weight >= 30
    AND weight <= 300
  GROUP BY
    patientunitstayid
  ORDER BY
    patientunitstayid ),
  demographics AS (
  SELECT
    p.patientUnitStayID,
    w.weight_avg,
    (CASE
        WHEN p.admissionHeight >90 AND p.admissionHeight <300 THEN p.admissionHeight ELSE NULL END) AS height,
    ROUND(CASE
        WHEN p.admissionHeight >90 AND p.admissionHeight < 300 THEN (10000*w.weight_avg/(p.admissionHeight*p.admissionHeight))
        ELSE NULL END) AS BMI,
    p.unitDischargeOffset
  FROM
    eicu_crd_v2.patient p
  LEFT JOIN
    weight w
  ON
    w.patientunitstayid = p.patientUnitStayID
  ORDER BY
    p.patientUnitStayID )
SELECT
  DISTINCT demographics.patientunitstayid,
  weight_avg AS weight,
  height,
  BMI,
  -- groups BMI values into categories
  CASE
    WHEN BMI < 18 THEN 'underweight'
    WHEN BMI >= 18 AND BMI < 25 THEN 'normal'
    WHEN BMI >= 25 THEN 'overweight'
    WHEN BMI >= 30 THEN 'obese'
    ELSE NULL
  END AS BMI_group
FROM
  demographics
LEFT JOIN
  eicu_crd_v2.apachepatientresult apachepatientresult
ON
  demographics.patientunitstayid = apachepatientresult.patientunitstayid
LEFT JOIN
  eicu_crd_v2.patient patient
ON
  demographics.patientunitstayid = patient.patientunitstayid