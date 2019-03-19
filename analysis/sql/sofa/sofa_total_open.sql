SELECT pt.patientunitstayid,
       max(sofa_cv_open.sofa_cv + sofa_respi_open.sofa_respi + sofa_renal_open.sofarenal + sofa_3others_open.sofacoag + sofa_3others_open.sofaliver + sofa_3others_open.sofacns) AS sofatotal
FROM eicu_crd_v2.patient pt
INNER JOIN public.sofa_cv_open ON pt.patientunitstayid = sofa_cv_open .patientunitstayid
INNER JOIN public.sofa_respi_open  ON pt.patientunitstayid = sofa_respi_open .patientunitstayid
INNER JOIN public.sofa_renal_open  ON pt.patientunitstayid = sofa_renal_open .patientunitstayid
INNER JOIN public.sofa_3others_open  ON pt.patientunitstayid = sofa_3others_open .patientunitstayid
GROUP BY pt.patientunitstayid
ORDER BY pt.patientunitstayid
