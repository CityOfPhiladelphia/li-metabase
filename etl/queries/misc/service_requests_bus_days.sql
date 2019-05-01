SELECT DISTINCT sr.servreqno,
  sr.address,
  sr.problemdescription,
  sr.calldate,
  sr.inspectiondate,
  sr.inspectionstatus,
  sr.resolutiondate,
  sr.resolutionstatus,
  (
  CASE
    WHEN sr.resolutiondescription IS NULL
    THEN '(none)'
    ELSE sr.resolutiondescription
  END ) resolutiondescription,
  sr.unit,
  sr.district,
  sr.SLA,
  sr.lon,
  sr.lat,
  bds2.BUSINESSDAYSSINCE - bds1.BUSINESSDAYSSINCE BDOutstanding,
  (
  CASE
    WHEN bds2.BUSINESSDAYSSINCE - bds1.BUSINESSDAYSSINCE <= sr.sla
    THEN 'Yes'
    ELSE 'No'
  END) WithinSLA,
  (
  CASE
    WHEN bds2.BUSINESSDAYSSINCE - bds1.BUSINESSDAYSSINCE <= sr.sla
    THEN NULL
    ELSE bds2.BUSINESSDAYSSINCE - bds1.BUSINESSDAYSSINCE - sr.sla
  END) BDOverdue
FROM SERVICE_REQUESTS sr,
  BUSINESS_DAYS_SINCE_2016 bds1,
  BUSINESS_DAYS_SINCE_2016 bds2
WHERE TO_DATE(TO_CHAR(sr.calldate, 'mm')
  || TO_CHAR(sr.calldate, 'dd')
  || TO_CHAR(sr.calldate, 'yyyy'), 'MMDDYYYY') = bds1.DATEOFYEAR (+)
AND TO_DATE(TO_CHAR(sr.inspectiondate, 'mm')
  || TO_CHAR(sr.inspectiondate, 'dd')
  || TO_CHAR(sr.inspectiondate, 'yyyy'), 'MMDDYYYY') = bds2.DATEOFYEAR (+)
AND sr.inspectiondate                               IS NOT NULL
UNION
SELECT DISTINCT sr.servreqno,
  sr.address,
  sr.problemdescription,
  sr.calldate,
  sr.inspectiondate,
  sr.inspectionstatus,
  sr.resolutiondate,
  sr.resolutionstatus,
  (
  CASE
    WHEN sr.resolutiondescription IS NULL
    THEN '(none)'
    ELSE sr.resolutiondescription
  END ) resolutiondescription,
  sr.unit,
  sr.district,
  sr.SLA,
  sr.lon,
  sr.lat,
  bds2.BUSINESSDAYSSINCE - bds1.BUSINESSDAYSSINCE BDOutstanding,
  (
  CASE
    WHEN bds2.BUSINESSDAYSSINCE - bds1.BUSINESSDAYSSINCE <= sr.sla
    THEN 'Yes'
    ELSE 'No'
  END) WithinSLA,
  (
  CASE
    WHEN bds2.BUSINESSDAYSSINCE - bds1.BUSINESSDAYSSINCE <= sr.sla
    THEN NULL
    ELSE bds2.BUSINESSDAYSSINCE - bds1.BUSINESSDAYSSINCE - sr.sla
  END) BDOverdue
FROM SERVICE_REQUESTS sr,
  BUSINESS_DAYS_SINCE_2016 bds1,
  BUSINESS_DAYS_SINCE_2016 bds2
WHERE TO_DATE(TO_CHAR(sr.calldate, 'mm')
  || TO_CHAR(sr.calldate, 'dd')
  || TO_CHAR(sr.calldate, 'yyyy'), 'MMDDYYYY') = bds1.DATEOFYEAR (+)
AND TO_DATE(TO_CHAR(SYSDATE, 'mm')
  || TO_CHAR(SYSDATE, 'dd')
  || TO_CHAR(SYSDATE, 'yyyy'), 'MMDDYYYY') = bds2.DATEOFYEAR (+)
AND sr.inspectiondate                     IS NULL