
WITH sq AS (SELECT
 p.uniquepid,
 p.patienthealthsystemstayid,
 p.patientunitstayid,
 ROW_NUMBER() OVER (PARTITION BY p.uniquepid ORDER BY p.hospitaladmitoffset DESC, p.patientunitstayid) AS POSITION
  , p.gender
  , case -- fixing age >89 to 93
                WHEN p.age LIKE '%89%' then 93 -- age avg of patients >89
				WHEN p.age = '' then NULL 
                ELSE p.age::integer end AS age_fixed
  , p.ethnicity
  -- the following 3 are useful when excluding patients with unreliable fluid data
  , p.hospitalid
  , p.wardid
  , p.hospitaldischargeyear
  , p.hospitaladmitsource
  , p.unittype
  , p.unitadmitsource
  , p.apacheadmissiondx
  , a.actualicumortality
  , p.hospitaldischargestatus
  , p.unitdischargestatus
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
  , a.apachescore -- APACHE score (versions IV and IVa
  , h.numbedscategory
  , h.teachingstatus
  , h.region
FROM eicu_crd_v2.patient p
LEFT JOIN eicu_crd_v2.apachepredvar s
  ON  p.patientunitstayid =s.patientunitstayid
LEFT JOIN eicu_crd_v2.apachepatientresult a
  ON p.patientunitstayid = a.patientunitstayid
LEFT JOIN eicu_crd_v2.apacheapsvar t
  ON p.patientunitstayid = t.patientunitstayid
LEFT JOIN eicu_crd_v2.hospital h
  ON p.hospitalID = h.hospitalid
--  AND hospitaldischargeyear IN (2014) /*In the end we are going to study all years*/
ORDER by p.uniquepid )
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
,hospitalid
,wardid
,hospitaldischargeyear
,hospitaladmitsource
,unittype
,unitadmitsource
,apacheadmissiondx
--,actualicumortality
,CASE WHEN LOWER(hospitaldischargestatus) ='alive'   OR LOWER(unitdischargestatus) ='alive'   THEN 0
      WHEN LOWER(hospitaldischargestatus) ='expired' OR LOWER(unitdischargestatus) ='expired' THEN 1
ELSE NULL      
END AS hospitalmortality
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
,numbedscategory
,teachingstatus
,region
FROM sq
WHERE position = 1 --first ICU admission
