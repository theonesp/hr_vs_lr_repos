-- This query is extracting first dialysis using different keywords from the table treatment and intakeoutput
-- Then 
WITH sq AS(
SELECT
	patientunitstayid ,
	treatmentoffset AS first_dialysis_offset,
	treatmentstring AS item
FROM
  treatment
WHERE
	treatmentstring  = 'endocrine|electrolyte correction|treatment of hyperkalemia|dialysis'
OR treatmentstring = 'renal|dialysis|C A V H D'
OR treatmentstring = 'renal|dialysis|C V V H'
OR treatmentstring = 'renal|dialysis|C V V H D'
OR treatmentstring = 'renal|dialysis|SLED'
OR treatmentstring = 'renal|dialysis|hemodialysis'
OR treatmentstring = 'renal|dialysis|hemodialysis|emergent'
OR treatmentstring = 'renal|dialysis|hemodialysis|for acute renal failure'
OR treatmentstring = 'renal|dialysis|hemodialysis|for chronic renal failure'
OR treatmentstring = 'renal|dialysis|peritoneal dialysis'
OR treatmentstring = 'renal|dialysis|peritoneal dialysis|emergent'
OR treatmentstring = 'renal|dialysis|peritoneal dialysis|for acute renal failure'
OR treatmentstring = 'renal|dialysis|peritoneal dialysis|for chronic renal failure'
OR treatmentstring = 'renal|dialysis|peritoneal dialysis|with cannula placement'
OR treatmentstring = 'renal|dialysis|ultrafiltration (fluid removal only)'
OR treatmentstring = 'renal|dialysis|ultrafiltration (fluid removal only)|emergent'
OR treatmentstring = 'renal|dialysis|ultrafiltration (fluid removal only)|for acute renal failure'
OR treatmentstring = 'renal|dialysis|ultrafiltration (fluid removal only)|for chronic renal failure'
OR treatmentstring = 'renal|electrolyte correction|treatment of hyperkalemia|dialysis'
OR treatmentstring = 'renal|electrolyte correction|treatment of hyperphosphatemia|dialysis'),
sq2 AS(
SELECT
	patientunitstayid ,
	item ,
	first_dialysis_offset ,
	ROW_NUMBER() OVER (PARTITION BY patientunitstayid ORDER BY first_dialysis_offset ASC) AS rn
FROM
	sq ),
sq3 AS(
SELECT
	patientunitstayid ,
	pasthistoryoffset ,
	pasthistorypath,
	ROW_NUMBER() OVER (PARTITION BY patientunitstayid ORDER BY pasthistoryoffset ASC) AS rn
FROM
  pasthistory
WHERE
	pasthistorypath LIKE '%Renal%'),
sq4 AS (	
SELECT
	DISTINCT
	patient.patientunitstayid
	, first_dialysis_offset
	, CASE
		WHEN patient.patientunitstayid = sq2.patientunitstayid THEN 1
		ELSE 0
	END AS dialysis_in_the_icu_bin 
	, CASE
		WHEN item = 'renal|dialysis|hemodialysis' THEN 'hemodialysis'
		WHEN item = 'renal|dialysis|C V V H D' THEN 'C V V H D'
		WHEN item = 'renal|dialysis|hemodialysis|emergent' THEN 'hemodialysis|emergent'
		WHEN item = 'renal|dialysis|hemodialysis|for acute renal failure' THEN 'for acute renal failure'
		WHEN item = 'renal|dialysis|C V V H' THEN 'C V V H'
		WHEN item = 'renal|dialysis|peritoneal dialysis' THEN 'peritoneal dialysis'
		WHEN item = 'renal|dialysis|C A V H D' THEN 'C A V H D'
		WHEN item = 'renal|dialysis|peritoneal dialysis|emergent' THEN 'dialysis|emergent'
		WHEN item = 'renal|dialysis|SLED' THEN 'SLED'
		WHEN item = 'renal|dialysis|peritoneal dialysis|for acute renal failure' THEN 'for acute renal failure'
		WHEN item = 'renal|dialysis|peritoneal dialysis|with cannula placement' THEN 'with cannula placement'
	END AS dialysis_cat 
	, CASE
		WHEN pasthistorypath = 'notes/Progress Notes/Past History/Organ Systems/Renal  (R)/Neurogenic Bladder/neurogenic bladder' THEN 'neurogenic bladder'
		WHEN pasthistorypath = 'notes/Progress Notes/Past History/Organ Systems/Renal  (R)/Chronic Stone Disease/chronic kidney stones' THEN 'chronic kidney stones'
		WHEN pasthistorypath = 'notes/Progress Notes/Past History/Organ Systems/Renal  (R)/Renal Insufficiency/renal insufficiency - creatinine 2-3' THEN 'renal insufficiency - creatinine 2-3'
		WHEN pasthistorypath = 'notes/Progress Notes/Past History/Organ Systems/Renal  (R)/Renal Failure/renal failure - peritoneal dialysis' THEN 'renal failure - peritoneal dialysis'
		WHEN pasthistorypath = 'notes/Progress Notes/Past History/Organ Systems/Renal  (R)/Renal Insufficiency/renal insufficiency - creatinine 3-4' THEN 'renal insufficiency - creatinine 3-4'
		WHEN pasthistorypath = 'notes/Progress Notes/Past History/Organ Systems/Renal  (R)/s/p Renal Transplant/s/p renal transplant' THEN 'renal transplant'
		WHEN pasthistorypath = 'notes/Progress Notes/Past History/Organ Systems/Renal  (R)/Renal Insufficiency/renal insufficiency - creatinine 4-5' THEN 'renal insufficiency - creatinine 4-5'
		WHEN pasthistorypath = 'notes/Progress Notes/Past History/Organ Systems/Renal  (R)/Renal Insufficiency/renal insufficiency - creatinine > 5' THEN 'renal insufficiency - creatinine > 5'
		WHEN pasthistorypath = 'notes/Progress Notes/Past History/Organ Systems/Renal  (R)/Renal Failure/renal failure - hemodialysis' THEN 'renal failure - hemodialysis'
		WHEN pasthistorypath = 'notes/Progress Notes/Past History/Organ Systems/Renal  (R)/Renal Insufficiency/renal insufficiency - creatinine 1-2' THEN 'renal insufficiency - creatinine 1-2'
		WHEN pasthistorypath = 'notes/Progress Notes/Past History/Organ Systems/Renal  (R)/Renal Failure/renal failure- not currently dialyzed' THEN 'renal failure- not currently dialyzed'
		WHEN pasthistorypath = 'notes/Progress Notes/Past History/Organ Systems/Renal  (R)/Renal Insufficiency/renal insufficiency - baseline creatinine unknown' THEN 'renal insufficiency - baseline creatinine unknown'
		WHEN pasthistorypath = 'notes/Progress Notes/Past History/Organ Systems/Renal  (R)/RTA/renal tubular acidosis' THEN 'renal tubular acidosis'
	END AS pasthistory_cat
FROM
	patient
LEFT JOIN sq2
		ON (patient.patientunitstayid = sq2.patientunitstayid AND sq2.rn = 1)
LEFT JOIN sq3
		ON (patient.patientunitstayid = sq3.patientunitstayid AND sq3.rn = 1)
)
SELECT
  patientunitstayid
, dialysis_in_the_icu_bin
, first_dialysis_offset
, dialysis_cat
, pasthistory_cat
, CASE
		WHEN dialysis_in_the_icu_bin = 1 AND pasthistory_cat != 'renal failure - peritoneal dialysis' AND pasthistory_cat != 'renal failure - hemodialysis' THEN 1 ELSE 0
  END AS acute_dialysis_bin 
, CASE
		WHEN dialysis_in_the_icu_bin = 1 AND pasthistory_cat IN( 'renal failure - peritoneal dialysis', 'renal failure - hemodialysis') THEN 1 ELSE 0
  END AS history_of_esrd_bin   --they already had AKI before ICU admin)
FROM
sq4
