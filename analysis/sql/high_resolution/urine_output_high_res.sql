-- This query extracts every data point of urine output BETWEEN 0 AND 24*60 from admission

SELECT
	patientunitstayid,
	chartoffset,
	outputtotal,
	urineoutput
FROM
	eicu_crd_derived.pivoted_uo
WHERE
	chartoffset BETWEEN 0 AND 24 * 60
ORDER BY
	patientunitstayid,
	chartoffset;
