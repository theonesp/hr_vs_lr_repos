
WITH sq AS (SELECT
 p.uniquepid,
 p.patienthealthsystemstayid,
 p.patientunitstayid,
 ROW_NUMBER() OVER (PARTITION BY p.uniquepid ORDER BY p.hospitaladmitoffset DESC, p.patientunitstayid) AS POSITION
  , p.gender
  , case -- fixing age >89 to 93
                WHEN p.age LIKE '%89%' then 93 -- age avg of patients >89
                ELSE p.age::integer end AS age_fixed
  , p.ethnicity
  , p.hospitaldischargeyear
  , p.hospitaladmitsource
  , p.unittype
  , p.unitadmitsource
  , p.apacheadmissiondx
  , a.actualicumortality
  , a.actualhospitalmortality
  , s.readmit
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
  , s.activetx
  , a.apachescore
  , h.teachingstatus
FROM eicu_crd_v2.patient p
LEFT JOIN eicu_crd_v2.apachepredvar s
  ON  p.patientunitstayid =s.patientunitstayid
LEFT JOIN eicu_crd_v2.apachepatientresult a
  ON p.patientunitstayid = a.patientunitstayid
LEFT JOIN eicu_crd_v2.apacheapsvar t
  ON p.patientunitstayid = t.patientunitstayid
LEFT JOIN eicu_crd_v2.hospital h
  ON p.hospitalID = h.hospitalid
WHERE p.apacheadmissiondx ILIKE '%sepsis%'
  AND s.readmit = 0
  AND p.age NOT IN ( '0', '1','2','3','4','5','6','7','8','9','10','11','12','13','14','15')
  AND a.actualhospitalmortality IS NOT NULL
  AND hospitaldischargeyear IN (2014)
  order by p.uniquepid )
 SELECT  patientunitstayid
,uniquepid
,patienthealthsystemstayid
,gender
/* ,CASE WHEN gender = 'Male' THEN 1
      WHEN gender = 'Female' THEN 2
      WHEN gender = 'Unknown' THEN 0
 END AS gender_fixed */   
,age_fixed
,ethnicity
,hospitaldischargeyear
,hospitaladmitsource
,unittype
,unitadmitsource
,apacheadmissiondx
,actualicumortality
/* ,CASE WHEN actualicumortality = 'ALIVE' THEN 0
      WHEN actualicumortality = 'EXPIRED' THEN 1
 END AS icumortality */
,actualhospitalmortality
/* ,CASE WHEN actualhospitalmortality = 'ALIVE' THEN 0
      WHEN actualhospitalmortality = 'EXPIRED' THEN 1
 END AS hospitalmortality */
,readmit
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
,activetx
,apachescore
,teachingstatus
FROM sq
WHERE position = 1 --first ICU admission
