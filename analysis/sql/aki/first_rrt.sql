WITH first_rrt_treatment AS
  (SELECT DISTINCT treatment.patientunitstayid,
   MIN (treatmentoffset) AS treatmentoffset
   FROM eicu_crd_v2.treatment
   WHERE Lower(treatment.treatmentstring) LIKE ANY ('{%rrt%,%dialysis%,%ultrafiltration%,%cavhd%,%cvvh%,%sled%}')
     AND Lower(treatment.treatmentstring) NOT LIKE '%chronic%'
   GROUP BY patientunitstayid),
   
  first_rrt_intakeoutput AS
  (SELECT DISTINCT intakeoutput.patientunitstayid,
   MIN (intakeoutputoffset) AS intakeoutputoffset
   FROM eicu_crd_v2.intakeoutput
   WHERE lower(intakeoutput.cellpath) LIKE ANY ('{%dialysis%,%cvvh%,%rrt%,%cavhd%,%sled%,%ultrafiltration%}')
   GROUP BY patientunitstayid)
   
SELECT pt.patientunitstayid
,LEAST (first_rrt_treatment.treatmentoffset, first_rrt_intakeoutput.intakeoutputoffset) AS first_rrtoffset
,1 AS rrt_bin
FROM eicu_crd_v2.patient pt
LEFT JOIN first_rrt_treatment ON first_rrt_treatment.patientunitstayid=pt.patientunitstayid
LEFT JOIN first_rrt_intakeoutput ON first_rrt_intakeoutput.patientunitstayid=pt.patientunitstayid
WHERE LEAST(first_rrt_treatment.treatmentoffset, first_rrt_intakeoutput.intakeoutputoffset) IS NOT NULL
ORDER BY patientunitstayid
