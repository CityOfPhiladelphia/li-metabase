SELECT 
  sla.jobnumber,
  sla.licensetype,
  sla.jobtype,
  sla.JOBCREATEDDATE,
  sla.JOBSTATUS,
  sla.CompletenessCheckStatus,
  sla.CompletenessCheckCompleted,  
  sla.joblink,
  bds1.BUSINESSDAYSSINCE BDSinceJobCreated,
  (
  CASE
    WHEN sla.CompletenessCheckCompleted is not null
    THEN 1
    ELSE 0
  END ) ProcessCompleted,
  bds2.BUSINESSDAYSSINCE BDSinceCompletenessCheck,
  bds2.BUSINESSDAYSSINCE - bds1.BUSINESSDAYSSINCE BDOpen,
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
AND TO_DATE(TO_CHAR(sla.CompletenessCheckCompleted, 'mm')
  || TO_CHAR(sla.CompletenessCheckCompleted, 'dd')
  || TO_CHAR(sla.CompletenessCheckCompleted, 'yyyy'), 'MMDDYYYY') = bds2.DATEOFYEAR (+)