-- This query extracts every data point of pressors in binary format BETWEEN 0 AND 24*60 from admission

SELECT
	patientunitstayid,
	MAX(CASE WHEN vasopressor = 1 AND chartoffset BETWEEN 0 AND 24 * 60 THEN 1 ELSE 0 END) AS vasopressor_bin_lr
FROM
	eicu_crd_derived.pivoted_treatment_vasopressor
GROUP BY
	patientunitstayid
