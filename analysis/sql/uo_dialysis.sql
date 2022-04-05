WITH t2 AS
  (WITH t1 AS
     (SELECT DISTINCT patientunitstayid,
                      intakeoutputoffset,
                      floor(intakeoutputoffset/1440)+1 AS FBday,
                      CASE
                          WHEN cellpath LIKE '%Intake%' THEN cellvaluenumeric
                          ELSE 0
                      END AS volinput,
                      CASE
                          WHEN cellpath LIKE '%Output%' THEN cellvaluenumeric
                          ELSE 0
                      END AS voloutput,
                      CASE
                          WHEN cellpath LIKE '%Dialysis%' THEN cellvaluenumeric
                          ELSE 0
                      END AS voldialysis -- cellvaluenumeric is always POSITIVE , DIALYSIStotal is NEGATIVE for fluid removal from RRT
-- distinct patientunitstayid, intakeoutputoffset, intaketotal, outputtotal, nettotal
FROM eicu_crd_v2.intakeoutput 
      WHERE cellpath IN ('flowsheet|Flowsheet Cell Labels|I&O|Output (ml)|Urine',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|Continuous infusion meds',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|NS ',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|NS IVF',
                         'flowsheet|Flowsheet Cell Labels|I&O|Output (ml)|URINE CATHETER',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|Other meds',
                         'flowsheet|Flowsheet Cell Labels|I&O|Output (ml)|Indwelling Catheter Output',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|NS',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|LR ',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|Crystalloids',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|D5NS ',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|IVPB',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Nutrition (ml)|TPN',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|IVPB',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|D5 0.45 NS ',
                         'flowsheet|Flowsheet Cell Labels|I&O|Output (ml)|Foley cath',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Blood Products (ml)|pRBCs',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|Volume (mL)-0.9 % sodium chloride solution',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|0.45 NS ',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|MIV',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|Volume (mL)-0.9 %  sodium chloride infusion',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|D51/2NS IVF',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|IV Drips',
                         'flowsheet|Flowsheet Cell Labels|I&O|Output (ml)|CATHETER OUTPUT',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|IVPB Volume (ml)',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|NS b IVF',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|LR IVF',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|Hourly In',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|NS  w/20 mEq KCL',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|Volume (mL)-0.45 % sodium chloride solution',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|1/2NS IVF',
                         'flowsheet|Flowsheet Cell Labels|I&O|Dialysis (ml)|Out',
                         'flowsheet|Flowsheet Cell Labels|I&O|Output (ml)|Urine, Cath:',
                         'flowsheet|Flowsheet Cell Labels|I&O|Output (ml)|Voided Amount',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|D5 0.45 NS  w/20 mEq KCL 1000 ml',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Blood Products (ml)|FFP',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|Volume (mL)-sodium chloride 0.9% infusion',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|TPN',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|D5 0.45 NS  w/20 mEq KCL',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|IV',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|I.V.',
                         'flowsheet|Flowsheet Cell Labels|I&O|Output (ml)|Foley',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|Volume (mL)-dextrose 5 % and 0.45 % sodium chloride with KCl 20 mEq/L infusion',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|D5NS IVF',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|D5 LR ',
                         'flowsheet|Flowsheet Cell Labels|I&O|Output (ml)|Urine, void:',
                         'flowsheet|Flowsheet Cell Labels|I&O|Output (ml)|Drain 1 Output mL',
                         'flowsheet|Flowsheet Cell Labels|I&O|Output (ml)|Actual Patient Fluid Removal',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|total',
                         'flowsheet|Flowsheet Cell Labels|I&O|Output (ml)|Blood Loss',
                         'flowsheet|Flowsheet Cell Labels|I&O|Output (ml)|total',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|Volume (mL)-lactated ringers infusion',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|Vascular Flush Amount (mL)',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|Saline Flush (mL)',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|PRESSURE LINE FLUSH',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Blood Products (ml)|Platelets',
                         'flowsheet|Flowsheet Cell Labels|I&O|Output (ml)|Chest Tube',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|LR',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|Volume (mL)-lactated ringers infusion',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|NS  w/40 mEq KCL 1000 ml',
                         'flowsheet|Flowsheet Cell Labels|I&O|Output (ml)|Hemofiltration',
                         'flowsheet|Flowsheet Cell Labels|I&O|Output (ml)|Urine foley',
                         'flowsheet|Flowsheet Cell Labels|I&O|Output (ml)|Hourly Out',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|Flush Total',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|D5NS',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|D5W  w/150 mEq NaHCO3 1000 ml',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|1/2 NS',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|Volume Expanders',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Nutrition (ml)|TPN w/fat emulsion',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|Hypertonic saline 3% ',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|Volume (mL)-0.9 % sodium chloride with potassium chloride 20 mEq/L infusion',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|TPN',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|Vascular 2 Flush Amount (mL)',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|D5NS  w/20 mEq KCL 1000 ml',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|NS KVO',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|PRESSURE LINE FLUSH',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|0.45 NS  w/20 mEq KCL 1000 ml',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|NS 0.9% Volume',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|IV/IVPB:',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|Total Lumen Flushes',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|D5 0.45 NS',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Colloids (ml)|5% Albumin',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|Volume (mL)-0.45 % sodium chloride infusion',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|0.45 NS',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|D5NS  w/20 mEq KCL',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|0.9 NS_c',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Nutrition (ml)|Fat emulsion 20%',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Nutrition (ml)|TPN:',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|D5 0.2 NS ',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|Electrolyte Other (volume)',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|D5 1/2 NS',
                         'flowsheet|Flowsheet Cell Labels|I&O|Output (ml)|Fluid Removed',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|Volume (mL)-dextrose 5 % and 0.45 % NaCl with KCl 20 mEq/L infusion',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|Per IV Flush: Antecubital R 20 gauge',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|Volume (ml) Heparin-heparin 25,000 units in dextrose 500 mL infusion',
                         'flowsheet|Flowsheet Cell Labels|I&O|Output (ml)|CRRT Actual Pt Fluid Removed',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|Volume (mL)-dextrose 5 % and 0.9% NaCl infusion',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|NS carrier',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Nutrition (ml)|TPN with insulin',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Nutrition (ml)|PPN/TNA/TPN',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|Volume (mL)-dextrose 5 % and 0.45% NaCl infusion',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|D5W  w/150 mEq NaHCO3',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|Volume (ml) Heparin',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|Volume (mL) Diltiazem',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|Volume (mL)-dextrose 5 % / sodium chloride 0.45% infusion',
                         'flowsheet|Flowsheet Cell Labels|I&O|Output (ml)|CRRT',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Nutrition (ml)|TPN w/fat emulsion 20%',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|NS Carrier',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|Banana Bag',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|Per IV Flush: Antecubital L 20 gauge',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|IV',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|0.45 NS  w/20 mEq KCL',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|IV Admix',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Generic Intake (ml)|Volume (mL)-0.9 % NaCl with KCl 20 mEq/ L  infusion',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|IV fluids',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|Volume (mL)-dextrose 5 %-0.9 % sodium chloride infusion',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|Volume (mL)-dextrose 5 % / sodium chloride 0.45% with KCl 20 mEq infusion',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|NS w/20 mEq  KCL',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|Crystalloid - Other',
                         'flowsheet|Flowsheet Cell Labels|I&O|Intake (ml)|Crystalloids (ml)|NS  w/40 mEq KCL')
        AND intakeoutputoffset BETWEEN 0 AND 4320 -- order by patientunitstayid, intakeoutputoffset
) SELECT patientunitstayid,
         FBday,
         sum(voloutput) AS UO_perday,
         sum(voldialysis) AS dialysis_output_perday,
         sum(voloutput + voldialysis) AS total_output_perday
   FROM t1
   GROUP BY patientunitstayid,
            FBday)
SELECT pt.patientunitstayid,
       max(CASE
               WHEN fbday=1 THEN uo_perday
               ELSE NULL
           END)AS uo_d1,
       max(CASE
               WHEN fbday=2 THEN uo_perday
               ELSE NULL
           END) AS uo_d2,
       max(CASE
               WHEN fbday=3 THEN uo_perday
               ELSE NULL
           END) AS uo_d3,
       max(CASE
               WHEN fbday=1 THEN dialysis_output_perday
               ELSE NULL
           END) AS dialysis_output_d1,
       max(CASE
               WHEN fbday=2 THEN dialysis_output_perday
               ELSE NULL
           END) AS dialysis_output_d2,
       max(CASE
               WHEN fbday=3 THEN dialysis_output_perday
               ELSE NULL
           END) AS dialysis_output_d3,
       max(CASE
               WHEN fbday=1 THEN total_output_perday
               ELSE NULL
           END) AS total_output_d1,
       max(CASE
               WHEN fbday=2 THEN total_output_perday
               ELSE NULL
           END) AS total_output_d2,
       max(CASE
               WHEN fbday=3 THEN total_output_perday
               ELSE NULL
           END) AS total_output_d3
FROM eicu_crd_v2.patient pt
LEFT OUTER JOIN t2 ON pt.patientunitstayid=t2.patientunitstayid
GROUP BY pt.patientunitstayid -- , t2.fbday -- , uo_perday, dialysis_output_perday, total_output_perday
ORDER BY pt.patientunitstayid
