-- this query detects whether the patient suffers from blood gas acidosis ( pH<7 ) in the first 3 days of ICU admission
SET search_path TO eicu_crd_v2;
WITH pivoted_bg AS (
-- get blood gas measures
with vw0 as
(
  select
      patientunitstayid
    , labname
    , labresultoffset
    , labresultrevisedoffset
  from lab
  where labname in
  (
      'pH'
  )
  group by patientunitstayid, labname, labresultoffset, labresultrevisedoffset
  having count(distinct labresult)<=1
)
-- get the last lab to be revised
, vw1 as
(
  select
      lab.patientunitstayid
    , lab.labname
    , lab.labresultoffset
    , lab.labresultrevisedoffset
    , lab.labresult
    , ROW_NUMBER() OVER
        (
          PARTITION BY lab.patientunitstayid, lab.labname, lab.labresultoffset
          ORDER BY lab.labresultrevisedoffset DESC
        ) as rn
  from lab
  inner join vw0
    ON  lab.patientunitstayid = vw0.patientunitstayid
    AND lab.labname = vw0.labname
    AND lab.labresultoffset = vw0.labresultoffset
    AND lab.labresultrevisedoffset = vw0.labresultrevisedoffset
  WHERE
  (lab.labname = 'pH' and lab.labresult >= 6.5 and lab.labresult <= 8.5)
)
select
    patientunitstayid
  , labresultoffset as chartoffset
  -- the aggregate (max()) only ever applies to 1 value due to the where clause
  , MAX(case when labname = 'pH' then labresult else null end) as pH
from vw1
where rn = 1
group by patientunitstayid, labresultoffset
order by patientunitstayid, labresultoffset)
SELECT
  patientunitstayid,
  MAX(CASE
      WHEN pH<7 THEN 1
      ELSE 0
    END)AS ph_under7
, MAX(CASE
      WHEN pH<7.1 THEN 1
      ELSE 0
    END)AS ph_under7_1    
FROM
  pivoted_bg
WHERE
  chartoffset BETWEEN 6*60 AND 3*24*60 -- first 3 days
GROUP BY
  patientunitstayid
