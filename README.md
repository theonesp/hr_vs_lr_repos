# hr_vs_lr_repos
## National Inpatient Survey (Administrative database) VS eICU (high resolution database)

Does the outcome change depending on the use of an administrative database versus a high resolution database? In order to answer the question:
_&nbsp;&nbsp;&nbsp;Is rrt an independent predictor for hospital mortality during ICU?_

We identified rrt as:

Patients containing: rrt OR ultrafiltration OR cavhd OR dialysis OR cvvh OR sled 
and not containing chronic

Our inclusion criteria are:
 - First ICU admission
 - apacheadmissiondx containing 'sepsis'
 - not readmited
 - age > 15
 - actualhospitalmortality IS NOT NULL
 - hospitaldischargeyear = 2014

