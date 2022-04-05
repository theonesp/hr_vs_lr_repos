-- This query extracts every data point of vitals BETWEEN 0 AND 24*60 from admission
-- For BP it takes nibp and in case it is not available it gathers ibp.

SELECT
	patientunitstayid,
	chartoffset,
	AVG(heartrate) AS heartrate,
	AVG(respiratoryrate) AS respiratoryrate,
	AVG(spo2) AS spo2,
	COALESCE (AVG(nibp_systolic), AVG(ibp_systolic)) AS sbp,
	COALESCE (AVG(nibp_diastolic), AVG(ibp_diastolic)) AS dbp,	
	COALESCE (AVG(nibp_mean), AVG(ibp_mean)) AS map,		
	AVG(temperature) AS temperature
FROM
	eicu_crd_derived.pivoted_vital
WHERE
chartoffset BETWEEN 0 AND 24*60
GROUP BY patientunitstayid, chartoffset
ORDER BY patientunitstayid, chartoffset
