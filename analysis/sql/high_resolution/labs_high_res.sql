-- This query extracts every data point of labs ETWEEN -6*60 AND 24*60
-- Most of the variables were found in pivoted_lab, those that were not were conveniently transformed to fit a pivoted fashion

-- We are also including the code for calculating the median in case it is not available
-- in your psql version.

/**CREATE OR REPLACE FUNCTION _final_median(numeric[])
   RETURNS numeric AS
$$
   SELECT AVG(val)
   FROM (
     SELECT val
     FROM unnest($1) val
     ORDER BY 1
     LIMIT  2 - MOD(array_upper($1, 1), 2)
     OFFSET CEIL(array_upper($1, 1) / 2.0) - 1
   ) sub;
$$
LANGUAGE 'sql' IMMUTABLE;

CREATE AGGREGATE median(numeric) (
  SFUNC=array_append,
  STYPE=numeric[],
  FINALFUNC=_final_median,
  INITCOND='{}'
);
**/

with pivoted_lab_curated AS(
SELECT
  patientunitstayid,
  chartoffset,
  MEDIAN(albumin) AS albumin,
  MEDIAN(bilirubin) AS bilirubin,
  MEDIAN(BUN) AS BUN,
  MEDIAN(calcium) AS calcium,
  MEDIAN(creatinine) AS creatinine,
  MEDIAN(glucose) AS glucose,
  MEDIAN(bicarbonate) AS bicarbonate,
  MEDIAN(TotalCO2) AS TotalCO2,
  MEDIAN(hematocrit) AS hematocrit,
  MEDIAN(hemoglobin) AS hemoglobin,
  MEDIAN(INR) AS INR,
  MEDIAN(lactate) AS lactate,
  MEDIAN(platelets) AS platelets,
  MEDIAN(potassium) AS potassium,
  MEDIAN(ptt) AS ptt,
  MEDIAN(sodium) AS sodium,
  MEDIAN(wbc) AS wbc,
  MEDIAN(bands) AS bands,
  MEDIAN(alt) AS alt,
  MEDIAN(ast) AS ast,
  MEDIAN(alp) AS alp
FROM
 eicu_crd_derived.pivoted_lab
WHERE
  chartoffset BETWEEN -6*60 AND 24*60
GROUP BY
  patientunitstayid,
  chartoffset  
), pivoted_bg_curated AS
(
SELECT
  patientunitstayid,
  chartoffset,
  fio2,
  ROW_NUMBER() OVER (PARTITION BY patientunitstayid ORDER BY chartoffset ASC) AS rn -- exclude first observation of fio2, that should reduce the right skeness.
FROM
 eicu_crd_derived.pivoted_bg
WHERE
  chartoffset BETWEEN -6*60 AND 24*60 
AND
  fio2 IS NOT NULL
 ), lab_curated AS
(
SELECT
  patientunitstayid,
  labresultoffset AS chartoffset,
  MAX(CASE WHEN labname = 'RDW' THEN labresult END) AS rdw,
  MAX(CASE WHEN labname = 'phosphate' THEN labresult END) AS phosphate,
  MAX(CASE WHEN labname = 'LDH' THEN labresult END) AS ldh
FROM
  eicu_crd_v2.lab
WHERE
  labresultoffset BETWEEN -6*60 AND 24*60
  AND labname IS NOT NULL
  AND labresult IS NOT NULL
GROUP BY
  patientunitstayid,
  labresultoffset
 )
SELECT
  pivoted_lab_curated.patientunitstayid,
  pivoted_lab_curated.chartoffset,
  MEDIAN(albumin) AS albumin,
  MEDIAN(bilirubin) AS bilirubin,
  MEDIAN(BUN) AS BUN,
  MEDIAN(calcium) AS calcium,
  MEDIAN(creatinine) AS creatinine,
  MEDIAN(glucose) AS glucose,
  MEDIAN(bicarbonate) AS bicarbonate,
  MEDIAN(TotalCO2) AS TotalCO2,
  MEDIAN(hematocrit) AS hematocrit,
  MEDIAN(hemoglobin) AS hemoglobin,
  MEDIAN(INR) AS inr,
  MEDIAN(lactate) AS lactate,
  MEDIAN(platelets) AS platelets,
  MEDIAN(potassium) AS potassium,
  MEDIAN(ptt) AS ptt,
  MEDIAN(sodium) AS sodium,
  MEDIAN(wbc) AS wbc,
  MEDIAN(bands) AS bands,
  MEDIAN(alt) AS alt,
  MEDIAN(ast) AS ast,
  MEDIAN(alp) AS alp,
  MEDIAN(fio2) AS fio2,
  MEDIAN(rdw) AS rdw,
  MEDIAN(phosphate) AS phosphate,
  MEDIAN(ldh) AS ldh
FROM
 pivoted_lab_curated
LEFT JOIN
 pivoted_bg_curated 
ON
pivoted_bg_curated.patientunitstayid = pivoted_lab_curated.patientunitstayid AND rn != 1 
/**Leo suggested the first fio2 measurement per patient might be causing the outlier we find in the distribution
so we are removing it**/ --It did not.
 AND
 pivoted_bg_curated.chartoffset = pivoted_lab_curated.chartoffset
LEFT JOIN
 lab_curated
ON
 lab_curated.patientunitstayid = pivoted_lab_curated.patientunitstayid
 AND
 lab_curated.chartoffset = pivoted_lab_curated.chartoffset
GROUP BY
  pivoted_lab_curated.patientunitstayid, pivoted_lab_curated.chartoffset 
ORDER BY
  patientunitstayid,
  chartoffset
