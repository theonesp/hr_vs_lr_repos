-- This query extracts every data point of specific pressors in bin format BETWEEN 0 AND 24*60 from admission

SELECT
	patientunitstayid,
	chartoffset,
	dopamine,
	dobutamine,
	norepinephrine,
	phenylephrine,
	epinephrine,
	vasopressin,
	milrinone,
	heparin
FROM
	eicu_crd_derived.pivoted_infusion
WHERE
	chartoffset BETWEEN 0 AND 24 * 60
ORDER BY
	patientunitstayid,
	chartoffset;
