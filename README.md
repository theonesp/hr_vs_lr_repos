# hr_vs_lr_repos
## National Inpatient Survey (Administrative database) VS eICU (high resolution database)

Does the outcome change depending on the use of an administrative database versus a high resolution database? In order to answer the question:
_Is rrt an independent predictor for hospital mortality during ICU?_

We identified rrt as:

Patients containing: rrt OR ultrafiltration OR cavhd OR dialysis OR cvvh OR sled 
and not containing chronic

Our Inclusion/Exclusion criteria are:

 - Including only First ICU admission.
 - Excluding age <16.
 - Including only Apache admission diagnosis containing '%sepsis%'.
 - Excluding patients who had a readmission.
 - Excluding patients with history of ESRD. 
 - Including only patients who developed AKI during ICU stay.
 - Including only patients with mechanical ventilation.
 - Including patients with actualhospitalmortality NOT NULL.
 - Including all years.

