-- This query extracts every data point of pressors in binary format BETWEEN 0 AND 24*60 from admission

SELECT
	patientunitstayid,
	chartoffset,
	vasopressor AS vasopressor_bin
FROM
	eicu_crd_derived.pivoted_treatment_vasopressor
WHERE
	chartoffset BETWEEN 0 AND 24 * 60
ORDER BY
	patientunitstayid,
	chartoffset
