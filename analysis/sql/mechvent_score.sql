  --Oxford Acute Severity of Illness Score (OASIS)
  -- This query extracts the Oxford acute severity of illness score in the eICU database.
  -- This score is a measure of severity of illness for patients in the ICU.
  -- The score is calculated on the first day of each ICU patients' stay.
  -- Reference for OASIS:
  --    Johnson, Alistair EW, Andrew A. Kramer, and Gari D. Clifford.
  --    "A new severity of illness scale using a subset of acute physiology and chronic health evaluation data elements shows comparable predictive accuracy*."
  --    Critical care medicine 41, no. 7 (2013): 1711-1718.
  -- Variables used in OASIS:
  --  Heart rate, GCS, MAP, Temperature, Respiratory rate, Ventilation status
  --  Urine output
  --  Elective surgery
  --  Pre-ICU in-hospital length of stay
  --  Age
  -- Note:
  --  The score is calculated for *all* ICU patients, with the assumption that the user will subselect appropriate ICUSTAY_IDs.
  --  For example, the score is calculated for neonates, but it is likely inappropriate to actually use the score values for these patients.
  -- TODO:
  -- the current query relies only on variables pre-recorded for the APACHE-IV score
  -- it may be advisable to use raw values for vital signs instead (HR, MAP, temp, RR)
  -- and record min and max values for the first 24h after ICU admission
  -- Some missing values in UO could be retrieved by extracting data from intakeoutput table
WITH
  mechvent_score AS (
  WITH
    oasiscomp AS (
    WITH
      t1 AS (
      SELECT
        patientunitstayid,
        age,
        verbal+motor+eyes AS gcs,
        CASE
          WHEN electivesurgery IS NOT NULL THEN 1
        ELSE
        0
      END
        AS electivesurgery
      FROM
        eicu_crd_v2.apachepredvar ),
      t2 AS (
      SELECT
        patientunitstayid,
        heartrate,
        meanbp,
        respiratoryrate AS resprate,
        temperature AS tempc,
        urine AS UrineOutput,
        vent AS mechvent
      FROM
        eicu_crd_v2.apacheapsvar )
    SELECT
      t1.patientunitstayid,
      t2.mechvent
    FROM
      t1
    LEFT JOIN
      t2
    ON
      t1.patientunitstayid=t2.patientunitstayid )
  SELECT
    patientunitstayid,
    CASE
      WHEN mechvent IS NULL THEN NULL
      WHEN mechvent = 1 THEN 9
    ELSE
    0
  END
    AS mechvent_score
  FROM
    oasiscomp)
SELECT
  *
FROM
  mechvent_score
