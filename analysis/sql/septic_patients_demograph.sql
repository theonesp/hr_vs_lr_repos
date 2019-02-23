
WITH sq AS (SELECT
 p.uniquepid,
 p.patienthealthsystemstayid,
 p.patientunitstayid,
 ROW_NUMBER() OVER (PARTITION BY p.uniquepid ORDER BY p.patientunitstayid ASC) AS position
  , p.gender
  , case -- fixing age >89 to 93
                WHEN p.age LIKE '%89%' then 93 -- age avg of patients >89
                ELSE p.age::integer end AS age_fixed
  , p.admissionheight AS height
  , p.admissionweight AS weight
  , p.ethnicity
  , p.hospitaldischargeyear
  , p.hospitaladmitsource
  , p.unittype
  , p.unitadmitsource
  , p.unitdischargetime24
  , p.apacheadmissiondx
  , a.actualicumortality
  , a.actualhospitalmortality
  , p.hospitalid
  , s.readmit
  , h.numbedscategory
  , h.teachingstatus
  , h.region
  , a.unabridgedunitlos
  , a.unabridgedhosplos
  , a.unabridgedactualventdays
  , t.intubated AS intubated_first_24h
  , s.aids
  , s.hepaticfailure
  , s.lymphoma
  , s.metastaticcancer
  , s.leukemia
  , s.immunosuppression
  , s.cirrhosis
  , s.diabetes
  , s.electivesurgery
  , t.dialysis AS chronic_dialysis_prior_to_hospital
  , s.activetx
  , a.apachescore
FROM eicu_crd_v2.patient p
LEFT JOIN eicu_crd_v2.apachepredvar s
  ON  p.patientunitstayid =s.patientunitstayid
LEFT JOIN eicu_crd_v2.apachepatientresult a
  ON p.patientunitstayid = a.patientunitstayid
LEFT JOIN eicu_crd_v2.apacheapsvar t
  ON p.patientunitstayid = t.patientunitstayid
LEFT JOIN eicu_crd_v2.hospital h
  ON  p.hospitalid = h.hospitalid
WHERE p.apacheadmissiondx ILIKE '%sepsis%'
  AND s.readmit = 0
  AND p.age NOT IN ( '0', '1','2','3','4','5','6','7','8','9','10','11','12','13','14','15')
  AND a.actualhospitalmortality IS NOT NULL
  AND hospitaldischargeyear = 2014
  order by p.uniquepid )
 SELECT  patientunitstayid
,uniquepid
,patienthealthsystemstayid
,gender
,age_fixed
,height
,weight
,ethnicity
,hospitaldischargeyear
,hospitaladmitsource
,unittype
,unitadmitsource
,unitdischargetime24
,apacheadmissiondx
,actualicumortality
,actualhospitalmortality
,hospitalid
,readmit
,numbedscategory
,teachingstatus
,region
,unabridgedunitlos
,unabridgedhosplos
,unabridgedactualventdays
,intubated_first_24h
,aids
,hepaticfailure
,lymphoma
,metastaticcancer
,leukemia
,immunosuppression
,cirrhosis
,diabetes
,electivesurgery
,chronic_dialysis_prior_to_hospital
,activetx
,apachescore FROM sq WHERE position = 1 --first ICU admission
;