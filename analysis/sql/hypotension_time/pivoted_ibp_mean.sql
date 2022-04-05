SET
  search_path TO eicu_crd_v2;
CREATE TABLE
  public.pivoted_ibp_mean AS
  -- create columns with only numeric data
WITH
  nc AS (
  SELECT
    patientunitstayid,
    nursingchartoffset,
    nursingchartentryoffset,
    CASE
      WHEN nursingchartcelltypevallabel = 'Invasive BP' AND nursingchartcelltypevalname = 'Invasive BP Mean' AND nursingchartvalue ~ '^[-]?[0-9]+[.]?[0-9]*$' AND nursingchartvalue NOT IN ('-', '.') THEN CAST(nursingchartvalue AS numeric)
    -- other map fields
      WHEN nursingchartcelltypevallabel = 'MAP (mmHg)'
    AND nursingchartcelltypevalname = 'Value'
    AND nursingchartvalue ~ '^[-]?[0-9]+[.]?[0-9]*$'
    AND nursingchartvalue NOT IN ('-',
      '.') THEN CAST(nursingchartvalue AS numeric)
      WHEN nursingchartcelltypevallabel = 'Arterial Line MAP (mmHg)' AND nursingchartcelltypevalname = 'Value' AND nursingchartvalue ~ '^[-]?[0-9]+[.]?[0-9]*$' AND nursingchartvalue NOT IN ('-', '.') THEN CAST(nursingchartvalue AS numeric)
      ELSE NULL
    END AS ibp_mean
  FROM
    eicu_crd_v2.nursecharting
    -- speed up by only looking at a subset of charted data
  WHERE
    nursingchartcelltypecat IN ( 'Vital Signs',
      'Scores',
      'Other Vital Signs and Infusions' ) )
SELECT
  patientunitstayid,
  nursingchartoffset AS chartoffset,
  nursingchartentryoffset AS entryoffset,
  AVG(CASE
      WHEN ibp_mean >= 1 AND ibp_mean <= 250 THEN ibp_mean
      ELSE NULL END) AS ibp_mean
FROM
  nc
WHERE
  ibp_mean IS NOT NULL
GROUP BY
  patientunitstayid,
  nursingchartoffset,
  nursingchartentryoffset
ORDER BY
  patientunitstayid,
  nursingchartoffset,
  nursingchartentryoffset;