-- This query extracts total fluid data point BETWEEN 0 AND 24*60 from admission for every icustay


WITH sq AS(
SELECT
	patientunitstayid,
	intakeoutputoffset,
	intaketotal,
	outputtotal,
	dialysistotal,
	nettotal
FROM
	eicu_crd_v2.intakeoutput
WHERE
	intakeoutputoffset BETWEEN 0 AND 24 * 60 )
SELECT
	patientunitstayid,
	SUM(intaketotal) AS intaketotal,
	SUM(outputtotal) AS outputtotal,
	SUM(dialysistotal) AS dialysistotal,
	SUM(nettotal) nettotal
FROM
	sq
GROUP BY
	patientunitstayid
ORDER BY
	patientunitstayid

