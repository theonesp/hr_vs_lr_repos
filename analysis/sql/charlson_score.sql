with t1 as
(
SELECT
	s.patientunitstayid,



 MAX (CASE WHEN ph.pasthistorypath IN (
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Metastases/other',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Metastases/brain',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Metastases/carcinomatosis',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Metastases/nodes',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Metastases/lung',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Metastases/intra-abdominal',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Metastases/bone',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Metastases/liver')
   THEN 6 ELSE 0 END) AS mets6,



 MAX (CASE WHEN ph.pasthistorypath = 'notes/Progress Notes/Past History/Organ Systems/Infectious Disease (R)/AIDS/AIDS' THEN 6 ELSE 0 END) AS aids6,



 MAX (CASE WHEN ph.pasthistorypath IN (
		'notes/Progress Notes/Past History/Organ Systems/Gastrointestinal (R)/Cirrhosis/UGI bleeding',
		'notes/Progress Notes/Past History/Organ Systems/Gastrointestinal (R)/Cirrhosis/varices',
		'notes/Progress Notes/Past History/Organ Systems/Gastrointestinal (R)/Cirrhosis/coma',
		'notes/Progress Notes/Past History/Organ Systems/Gastrointestinal (R)/Cirrhosis/jaundice',
		'notes/Progress Notes/Past History/Organ Systems/Gastrointestinal (R)/Cirrhosis/ascites',
		'notes/Progress Notes/Past History/Organ Systems/Gastrointestinal (R)/Cirrhosis/encephalopathy')
   THEN 3 ELSE 0 END) AS liver3,



 MAX (CASE WHEN ph.pasthistorypath IN (
		'notes/Progress Notes/Past History/Organ Systems/Neurologic/Strokes/multiple/multiple',
		'notes/Progress Notes/Past History/Organ Systems/Neurologic/Strokes/stroke - remote',
		'notes/Progress Notes/Past History/Organ Systems/Neurologic/Strokes/stroke - within 5 years',
		'notes/Progress Notes/Past History/Organ Systems/Neurologic/Strokes/stroke - within 2 years',
		'notes/Progress Notes/Past History/Organ Systems/Neurologic/Strokes/stroke - date unknown',
		'notes/Progress Notes/Past History/Organ Systems/Neurologic/Strokes/stroke - within 6 months')
		THEN 2 ELSE 0 END) AS stroke2,



 MAX (CASE WHEN ph.pasthistorypath IN (
		'notes/Progress Notes/Past History/Organ Systems/Renal  (R)/Renal Insufficiency/renal insufficiency - creatinine 1-2',
		'notes/Progress Notes/Past History/Organ Systems/Renal  (R)/Renal Insufficiency/renal insufficiency - creatinine 3-4',
		'notes/Progress Notes/Past History/Organ Systems/Renal  (R)/Renal Insufficiency/renal insufficiency - creatinine > 5',
		'notes/Progress Notes/Past History/Organ Systems/Renal  (R)/Renal Insufficiency/renal insufficiency - baseline creatinine unknown',
		'notes/Progress Notes/Past History/Organ Systems/Renal  (R)/Renal Insufficiency/renal insufficiency - creatinine 4-5',
		'notes/Progress Notes/Past History/Organ Systems/Renal  (R)/Renal Insufficiency/renal insufficiency - creatinine 2-3',
		'notes/Progress Notes/Past History/Organ Systems/Renal  (R)/Renal Failure/renal failure - peritoneal dialysis',
		'notes/Progress Notes/Past History/Organ Systems/Renal  (R)/Renal Failure/renal failure- not currently dialyzed',
		'notes/Progress Notes/Past History/Organ Systems/Renal  (R)/Renal Failure/renal failure - hemodialysis')
		THEN 2 ELSE 0 END) AS renal2,



 MAX (CASE WHEN ph.pasthistorypath IN (
		'notes/Progress Notes/Past History/Organ Systems/Endocrine (R)/Insulin Dependent Diabetes/insulin dependent diabetes',
		'notes/Progress Notes/Past History/Organ Systems/Endocrine (R)/Non-Insulin Dependent Diabetes/non-medication dependent',
		'notes/Progress Notes/Past History/Organ Systems/Endocrine (R)/Non-Insulin Dependent Diabetes/medication dependent')
		THEN 1 ELSE 0 END) AS dm,



 MAX (CASE WHEN ph.pasthistorypath IN (
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer Therapy/Chemotherapy/Anthracyclines (adriamycin, daunorubicin)',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Cancer-Primary Site/bone',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Cancer-Primary Site/stomach',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Cancer-Primary Site/bile duct',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Cancer-Primary Site/kidney',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Cancer-Primary Site/unknown',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer Therapy/Radiation Therapy within past 6 months/primary site',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Cancer-Primary Site/breast',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Cancer-Primary Site/uterus',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer Therapy/Radiation Therapy within past 6 months/bone',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Cancer-Primary Site/prostate',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Cancer-Primary Site/liver',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Cancer-Primary Site/pancreas - adenocarcinoma',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Cancer-Primary Site/ovary',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer Therapy/Radiation Therapy within past 6 months/other',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Cancer-Primary Site/sarcoma',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer Therapy/Chemotherapy/chemotherapy within past mo.',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Cancer-Primary Site/other',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer Therapy/Chemotherapy/Alkylating agents (bleomycin, cytoxan, cyclophos.)',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Cancer-Primary Site/testes',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Cancer-Primary Site/lung',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Cancer-Primary Site/melanoma',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer Therapy/Radiation Therapy within past 6 months/nodes',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer Therapy/Chemotherapy/BMT within past 12 mos.',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer Therapy/Chemotherapy/Cis-platinum',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer Therapy/Radiation Therapy within past 6 months/liver',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Cancer-Primary Site/head and neck',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Cancer-Primary Site/esophagus',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Cancer-Primary Site/bladder',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer Therapy/Chemotherapy/chemotherapy within past 6 mos.',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer Therapy/Radiation Therapy within past 6 months/lung',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Cancer-Primary Site/none',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Cancer-Primary Site/pancreas - islet cell',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Cancer-Primary Site/colon',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer Therapy/Radiation Therapy within past 6 months/brain',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer Therapy/Chemotherapy/Vincristine',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Cancer-Primary Site/brain')
   THEN 2 ELSE 0 END) as cancer2,



 MAX (CASE WHEN ph.pasthistorypath IN (
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Hematologic Malignancy/AML',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Hematologic Malignancy/ALL',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Hematologic Malignancy/CLL',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Hematologic Malignancy/CML',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Hematologic Malignancy/leukemia - other')
   THEN 2 ELSE 0 END) as leukemia2,



 MAX (CASE WHEN ph.pasthistorypath IN (
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Hematologic Malignancy/non-Hodgkins lymphoma',
		'notes/Progress Notes/Past History/Organ Systems/Hematology/Oncology (R)/Cancer/Hematologic Malignancy/Hodgkins disease')
   THEN 2 ELSE 0 END) as lymphoma2,



 MAX (CASE WHEN ph.pasthistorypath IN(
		'notes/Progress Notes/Past History/Organ Systems/Cardiovascular (R)/Myocardial Infarction/MI - within 5 years',
		'notes/Progress Notes/Past History/Organ Systems/Cardiovascular (R)/Myocardial Infarction/MI - remote',
		'notes/Progress Notes/Past History/Organ Systems/Cardiovascular (R)/Myocardial Infarction/MI - within 6 months',
		'notes/Progress Notes/Past History/Organ Systems/Cardiovascular (R)/Myocardial Infarction/MI - date unknown',
		'notes/Progress Notes/Past History/Organ Systems/Cardiovascular (R)/Myocardial Infarction/MI - within 2 years',
		'notes/Progress Notes/Past History/Organ Systems/Cardiovascular (R)/Myocardial Infarction/multiple/multiple')
   THEN 1 ELSE 0 END) AS mi1,



 MAX (CASE WHEN ph.pasthistorypath IN (
		'notes/Progress Notes/Past History/Organ Systems/Cardiovascular (R)/Congestive Heart Failure/CHF - class I',
		'notes/Progress Notes/Past History/Organ Systems/Cardiovascular (R)/Congestive Heart Failure/CHF - class II',
		'notes/Progress Notes/Past History/Organ Systems/Cardiovascular (R)/Congestive Heart Failure/CHF - severity unknown',
		'notes/Progress Notes/Past History/Organ Systems/Cardiovascular (R)/Congestive Heart Failure/CHF - class III',
		'notes/Progress Notes/Past History/Organ Systems/Cardiovascular (R)/Congestive Heart Failure/CHF',
		'notes/Progress Notes/Past History/Organ Systems/Cardiovascular (R)/Congestive Heart Failure/CHF - class IV')
   THEN 1 ELSE 0 END) AS chf1,



 MAX (CASE WHEN ph.pasthistorypath = 'notes/Progress Notes/Past History/Organ Systems/Cardiovascular (R)/Peripheral Vascular Disease/peripheral vascular disease' THEN 1 ELSE 0 END) AS pvd1,



 MAX (CASE WHEN ph.pasthistorypath IN (
		'notes/Progress Notes/Past History/Organ Systems/Neurologic/TIA(s)/TIA(s) - within 6 months',
		'notes/Progress Notes/Past History/Organ Systems/Neurologic/TIA(s)/TIA(s) - within 2 years',
		'notes/Progress Notes/Past History/Organ Systems/Neurologic/TIA(s)/TIA(s) - remote',
		'notes/Progress Notes/Past History/Organ Systems/Neurologic/TIA(s)/TIA(s) - within 5 years',
		'notes/Progress Notes/Past History/Organ Systems/Neurologic/TIA(s)/multiple/multiple',
		'notes/Progress Notes/Past History/Organ Systems/Neurologic/TIA(s)/TIA(s) - date unknown')
     THEN 1 ELSE 0 END) AS tia1,



 MAX (CASE WHEN ph.pasthistorypath = 'notes/Progress Notes/Past History/Organ Systems/Neurologic/Dementia/dementia' THEN 1 ELSE 0 END) AS dementia1,



 MAX (CASE WHEN ph.pasthistorypath IN (
		'notes/Progress Notes/Past History/Organ Systems/Pulmonary/COPD/COPD  - no limitations',
		'notes/Progress Notes/Past History/Organ Systems/Pulmonary/COPD/COPD  - moderate',
		'notes/Progress Notes/Past History/Organ Systems/Pulmonary/COPD/COPD  - severe')
   THEN 1 ELSE 0 END) AS copd1,



 MAX (CASE WHEN ph.pasthistorypath IN (
		'notes/Progress Notes/Past History/Organ Systems/Rheumatic/SLE/SLE',
		'notes/Progress Notes/Past History/Organ Systems/Rheumatic/Rheumatoid Arthritis/rheumatoid arthritis',
		'notes/Progress Notes/Past History/Organ Systems/Rheumatic/Scleroderma/scleroderma',
		'notes/Progress Notes/Past History/Organ Systems/Rheumatic/Vasculitis/vasculitis',
		'notes/Progress Notes/Past History/Organ Systems/Rheumatic/Dermato/Polymyositis/dermatomyositis')
   THEN 1 ELSE 0 END) AS ctd1,



 MAX (CASE WHEN ph.pasthistorypath IN (
		'notes/Progress Notes/Past History/Organ Systems/Gastrointestinal (R)/Peptic Ulcer Disease/peptic ulcer disease',
		'notes/Progress Notes/Past History/Organ Systems/Gastrointestinal (R)/Peptic Ulcer Disease/peptic ulcer disease with h/o GI bleeding',
		'notes/Progress Notes/Past History/Organ Systems/Gastrointestinal (R)/Peptic Ulcer Disease/hx GI bleeding/no')
   THEN 1 ELSE 0 END) AS pud1,



 MAX (CASE WHEN ph.pasthistorypath IN (
		'notes/Progress Notes/Past History/Organ Systems/Gastrointestinal (R)/Cirrhosis/clinical diagnosis',
		'notes/Progress Notes/Past History/Organ Systems/Gastrointestinal (R)/Cirrhosis/biopsy proven')
   THEN 1 ELSE 0 END) as liver1,

Case when s.age like '>%89'  then 5
when s.age like '' then 0
when s.age::numeric between 80 and 89 then 4
when s.age::numeric between 70 and 79 then 3
when s.age::numeric between 60 and 69 then 2
when s.age::numeric between 50 and 59 then 1

else 0 end as age_score_charlson



FROM eicu_crd.patient s
LEFT JOIN eicu_crd.pasthistory ph
ON s.patientunitstayid = ph.patientunitstayid
GROUP BY s.patientunitstayid, s.age
ORDER BY s.patientunitstayid
)

Select t1.*, (t1.mets6+t1.aids6+t1.liver3+t1.stroke2+t1.renal2+t1.dm+t1.cancer2+t1.leukemia2+t1.lymphoma2+t1.mi1+ t1.chf1+t1.pvd1+t1.tia1+t1.dementia1+t1.copd1+t1.ctd1+t1.pud1+t1.liver1 + t1.age_score_charlson)as Final_Charlson_score
from t1
order by t1.patientunitstayid
