WITH oasis AS
  (WITH oasiscomp AS
     (WITH t1 AS
        (SELECT patientunitstayid,
                age,
                verbal+motor+eyes AS gcs,
                CASE
                    WHEN electivesurgery IS NOT NULL THEN 1
                    ELSE 0
                END AS electivesurgery
         FROM eicu_crd_v2.apachepredvar
        ),t2 AS
        (SELECT patientunitstayid,
                heartrate,
                meanbp,
                respiratoryrate AS resprate,
                temperature AS tempc,
                urine AS UrineOutput,
                vent AS mechvent
         FROM eicu_crd_v2.apacheapsvar
 ),           t3 AS
        (SELECT patientunitstayid, -hospitaladmitoffset/60 AS preiculos
         FROM eicu_crd_v2.patient
) SELECT t1.patientunitstayid,
                                     t3.preiculos,
                                     t1.age,
                                     t1.gcs,
                                     t2.heartrate,
                                     t2.meanbp,
                                     t2.resprate,
                                     t2.tempc,
                                     t2.UrineOutput,
                                     t2.mechvent,
                                     t1.electivesurgery
      FROM t1 LEFT OUTER JOIN t2 ON t1.patientunitstayid=t2.patientunitstayid
      LEFT OUTER JOIN t3 ON t2.patientunitstayid=t3.patientunitstayid
) SELECT patientunitstayid,
         CASE
             WHEN preiculos IS NULL THEN NULL
             WHEN preiculos < 0.17 THEN 5
             WHEN preiculos < 4.94 THEN 3
             WHEN preiculos < 24 THEN 0
             WHEN preiculos > 311.8 THEN 1
             ELSE 2
         END AS preiculos_score,
         CASE
             WHEN age IS NULL THEN NULL
             WHEN age < 24 THEN 0
             WHEN age <= 53 THEN 3
             WHEN age <= 77 THEN 6
             WHEN age <= 89 THEN 9
             WHEN age >= 90 THEN 7
             ELSE 0
         END AS age_score,
         CASE
             WHEN gcs IS NULL THEN NULL
             WHEN gcs <= 7 THEN 10
             WHEN gcs < 14 THEN 4
             WHEN gcs = 14 THEN 3
             ELSE 0
         END AS gcs_score,
         CASE
             WHEN heartrate IS NULL THEN NULL
             WHEN heartrate > 125 THEN 6
             WHEN heartrate < 33 THEN 4
             WHEN heartrate >= 107
                  AND heartrate <= 125 THEN 3
             WHEN heartrate >= 89
                  AND heartrate <= 106 THEN 1
             ELSE 0
         END AS heartrate_score,
         CASE
             WHEN meanbp IS NULL THEN NULL
             WHEN meanbp < 20.65 THEN 4
             WHEN meanbp < 51 THEN 3
             WHEN meanbp > 143.44 THEN 3
             WHEN meanbp >= 51
                  AND meanbp < 61.33 THEN 2
             ELSE 0
         END AS meanbp_score,
         CASE
             WHEN resprate IS NULL THEN NULL
             WHEN resprate < 6 THEN 10
             WHEN resprate > 44 THEN 9
             WHEN resprate > 30 THEN 6
             WHEN resprate > 22 THEN 1
             WHEN resprate < 13 THEN 1
             ELSE 0
         END AS resprate_score,
         CASE
             WHEN tempc IS NULL THEN NULL
             WHEN tempc > 39.88 THEN 6
             WHEN tempc >= 33.22
                  AND tempc <= 35.93 THEN 4
             WHEN tempc >= 33.22
                  AND tempc <= 35.93 THEN 4
             WHEN tempc < 33.22 THEN 3
             WHEN tempc > 35.93
                  AND tempc <= 36.39 THEN 2
             WHEN tempc >= 36.89
                  AND tempc <= 39.88 THEN 2
             ELSE 0
         END AS temp_score,
         CASE
             WHEN UrineOutput IS NULL THEN NULL
             WHEN UrineOutput < 671.09 THEN 10
             WHEN UrineOutput > 6896.80 THEN 8
             WHEN UrineOutput >= 671.09
                  AND UrineOutput <= 1426.99 THEN 5
             WHEN UrineOutput >= 1427.00
                  AND UrineOutput <= 2544.14 THEN 1
             ELSE 0
         END AS UrineOutput_score,
         CASE
             WHEN mechvent IS NULL THEN NULL
             WHEN mechvent = 1 THEN 9
             ELSE 0
         END AS mechvent_score,
         CASE
             WHEN electivesurgery IS NULL THEN NULL
             WHEN electivesurgery = 1 THEN 0
             ELSE 6
         END AS electivesurgery_score
   FROM oasiscomp)
SELECT * ,
       coalesce(age_score, 0) + coalesce(preiculos_score, 0) + coalesce(gcs_score, 0) + coalesce(heartrate_score, 0) + coalesce(meanbp_score, 0) + coalesce(resprate_score, 0) + coalesce(temp_score, 0) + coalesce(urineoutput_score, 0) + coalesce(mechvent_score, 0) + coalesce(electivesurgery_score, 0) AS OASIS
FROM oasis
