SELECT DISTINCT treatment.patientunitstayid
   FROM treatment
   WHERE Lower(treatment.treatmentstring) LIKE ANY ('{%rrt%,%dialysis%,%ultrafiltration%,%cavhd%,%cvvh%,%sled%}')
     AND Lower(treatment.treatmentstring) LIKE '%chronic%'
   GROUP BY patientunitstayid
   ORDER BY patientunitstayid ASC