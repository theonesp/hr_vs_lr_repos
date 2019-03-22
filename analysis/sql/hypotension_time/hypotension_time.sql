-- Since hipotension sampling time is constantly changing inter and intra-patients, an estimation was made
-- How the estimation works:
-- it calculates the median sampling time per patient (mean would be more affected by outliers)
-- counts each datapoint <65 of ibp mean, every data-point is then multiplied by the median sampling time of that patient.
-- the hypotension time was calculated for the first 3 days of ICU admission
-- total hypotension time can not be greater than 3 days.
-- total hypotension time is calculated in minutes
WITH diffs as (
    SELECT
        patientunitstayid,
        chartoffset - lag(chartoffset) over (partition BY patientunitstayid ORDER BY chartoffset) as difference
    FROM
        public.pivoted_ibp_mean
WHERE
chartoffset BETWEEN 0 AND 3*24*60 --ibp_mean data from the first 3 days
), median_sampling_time AS(
SELECT
    patientunitstayid,
    MEDIAN( difference )::INTEGER as median_sp --median sampling time
FROM
    diffs
GROUP BY patientunitstayid
--USING THIS FIRST 2 queries we calculate the median sampling time per patient.
), pivoted_ibp_mean_first3days AS (
SELECT 
*
FROM
public.pivoted_ibp_mean 
WHERE
chartoffset BETWEEN 0 AND 3*24*60 --ibp_mean data from the first 3 days
) 
SELECT
pivoted_ibp_mean_first3days.patientunitstayid
,COUNT(ibp_mean)*median_sp AS estimated_hypotension_time
FROM
pivoted_ibp_mean_first3days
INNER JOIN
median_sampling_time
ON
pivoted_ibp_mean_first3days.patientunitstayid = median_sampling_time.patientunitstayid
WHERE 
ibp_mean < 65 -- hipotension definition
AND
median_sp IS NOT NULL
GROUP BY
pivoted_ibp_mean_first3days.patientunitstayid, median_sp
HAVING
COUNT(ibp_mean)*median_sp <= 3*24*60 --total hipotension time can not be greater than 3 days
ORDER BY patientunitstayid
