-- We've used non invasive mean bp and when not available, we extracted invasive mean bp.
-- Since hipotension sampling time is constantly changing inter and intra-patients, an estimation was made
-- How the estimation works:
-- it calculates the median sampling time per patient (mean would be more affected by outliers)
-- counts each datapoint <65 of ibp mean, every data-point is then multiplied by the median sampling time of that patient.
-- the hypotension time was calculated for the first 3 days of ICU admission
-- total hypotension time can not be greater than 3 days.
-- total hypotension time is calculated in minutes
WITH
  pivoted_bp_mean AS(
  -- create columns with only numeric data
WITH
  nc AS (
  SELECT
    patientunitstayid,
    nursingchartoffset,
    nursingchartentryoffset,
    CASE
      WHEN nursingchartcelltypevallabel = 'Non-Invasive BP' AND nursingchartcelltypevalname = 'Non-Invasive BP Mean' AND nursingchartvalue ~ '^[-]?[0-9]+[.]?[0-9]*$' AND nursingchartvalue NOT IN ('-', '.') THEN CAST(nursingchartvalue AS numeric)
      ELSE NULL
    END AS nibp_mean,
    CASE
      WHEN nursingchartcelltypevallabel = 'Invasive BP' AND nursingchartcelltypevalname = 'Invasive BP Mean' AND nursingchartvalue ~ '^[-]?[0-9]+[.]?[0-9]*$' AND nursingchartvalue NOT IN ('-', '.') THEN CAST(nursingchartvalue AS numeric)
    -- other map fields
      WHEN nursingchartcelltypevallabel = 'MAP (mmHg)'
    AND nursingchartcelltypevalname = 'Value'
    AND nursingchartvalue ~ '^[-]?[0-9]+[.]?[0-9]*$'
    AND nursingchartvalue NOT IN ('-','.') THEN CAST(nursingchartvalue AS numeric)
      WHEN nursingchartcelltypevallabel = 'Arterial Line MAP (mmHg)' AND nursingchartcelltypevalname = 'Value' AND nursingchartvalue ~ '^[-]?[0-9]+[.]?[0-9]*$' AND nursingchartvalue NOT IN ('-', '.') THEN CAST(nursingchartvalue AS numeric)
      ELSE NULL
    END AS ibp_mean
  FROM
    eicu_crd_v2.nursecharting
    -- speed up by only looking at a subset of charted data
  WHERE
    nursingchartcelltypecat IN ( 'Vital Signs','Scores','Other Vital Signs and Infusions' ) )
SELECT
  patientunitstayid,
  nursingchartoffset AS chartoffset,
  nursingchartentryoffset AS entryoffset,
  AVG(CASE
      WHEN nibp_mean >= 1 AND nibp_mean <= 250 THEN nibp_mean
      ELSE NULL END) AS nibp_mean,
  AVG(CASE
      WHEN ibp_mean >= 1 AND ibp_mean <= 250 THEN ibp_mean
      ELSE NULL END) AS ibp_mean
FROM
  nc
WHERE
  nibp_mean IS NOT NULL
  OR ibp_mean IS NOT NULL
GROUP BY
  patientunitstayid,
  nursingchartoffset,
  nursingchartentryoffset
ORDER BY
  patientunitstayid,
  nursingchartoffset,
  nursingchartentryoffset
  ), diffs as (
SELECT
  patientunitstayid,
  chartoffset - lag(chartoffset) over (partition BY patientunitstayid ORDER BY chartoffset) as difference
FROM
  pivoted_bp_mean
WHERE
chartoffset BETWEEN -6*60 AND 3*24*60 --bp_mean data BETWEEN -6 hrs and first 3 days of ICU stay
), median_sampling_time AS(
SELECT
    patientunitstayid,
    MEDIAN( difference )::INTEGER as median_sp --median sampling time
FROM
    diffs
GROUP BY patientunitstayid
-- using these first 2 queries we calculate the median sampling time per patient.
), pivoted_bp_mean_first3days AS (
SELECT 
 patientunitstayid
 ,chartoffset
,CASE WHEN COALESCE(nibp_mean,ibp_mean)<65 THEN COALESCE(nibp_mean,ibp_mean) END AS bp_mean
FROM
pivoted_bp_mean 
WHERE
chartoffset BETWEEN -6*60 AND 3*24*60 --bp_mean data BETWEEN -6 hrs and first 3 days of ICU stay
--GROUP BY patientunitstayid ,chartoffset,COALESCE(nibp_mean,ibp_mean)
--HAVING COALESCE(nibp_mean,ibp_mean) < 65

) 
SELECT
 pivoted_bp_mean_first3days.patientunitstayid
,COUNT(bp_mean)*median_sp AS estimated_hypotension_time
FROM
pivoted_bp_mean_first3days
INNER JOIN
median_sampling_time
ON
pivoted_bp_mean_first3days.patientunitstayid = median_sampling_time.patientunitstayid
WHERE 
median_sp IS NOT NULL
GROUP BY
pivoted_bp_mean_first3days.patientunitstayid, median_sp
HAVING 
COUNT(bp_mean)*median_sp <= 3*24*60
ORDER BY patientunitstayid
