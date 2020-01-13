SELECT 
  sla.jobnumber,
  sla.licensetype,
  sla.jobtype,
  sla.JOBCREATEDDATE,
  sla.JOBSTATUS,
  sla.FirstCompCheckCompleted,  
  sla.joblink,
  bds1.BUSINESSDAYSSINCE BDSinceJobCreated,
  (
  CASE
    WHEN sla.FirstCompCheckCompleted is not null
    THEN 1
    ELSE 0
  END ) ProcessCompleted,
  bds2.BUSINESSDAYSSINCE BDSinceCompletenessCheck,
  (
  CASE
    WHEN sla.FirstCompCheckCompleted is not null
    THEN bds2.BUSINESSDAYSSINCE - bds1.BUSINESSDAYSSINCE
    ELSE bds1.BUSINESSDAYSSINCE
  END ) BDOpen,
  (
  CASE
    WHEN bds2.BUSINESSDAYSSINCE - bds1.BUSINESSDAYSSINCE <= 2
    THEN 1
    ELSE 0
  END ) WithinSLA
FROM SLA_BL sla,
  BUSINESS_DAYS_SINCE_2017 bds1,
  BUSINESS_DAYS_SINCE_2017 bds2
WHERE TO_DATE(TO_CHAR(sla.JOBCREATEDDATE, 'mm')
  || TO_CHAR(sla.JOBCREATEDDATE, 'dd')
  || TO_CHAR(sla.JOBCREATEDDATE, 'yyyy'), 'MMDDYYYY') = bds1.DATEOFYEAR (+)
AND TO_DATE(TO_CHAR(sla.FirstCompCheckCompleted, 'mm')
  || TO_CHAR(sla.FirstCompCheckCompleted, 'dd')
  || TO_CHAR(sla.FirstCompCheckCompleted, 'yyyy'), 'MMDDYYYY') = bds2.DATEOFYEAR (+)