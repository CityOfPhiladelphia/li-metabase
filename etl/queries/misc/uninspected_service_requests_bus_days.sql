SELECT DISTINCT u.servreqno,
  u.address,
  u.problemdescription,
  u.calldate,
  bds1.BUSINESSDAYSSINCE BDTilCallDate,
  u.unit,
  u.district,
  u.SLA,
  u.lon,
  u.lat,
  bds2.BUSINESSDAYSSINCE - bds1.BUSINESSDAYSSINCE BDOutstanding,
  (
  CASE
    WHEN bds2.BUSINESSDAYSSINCE - bds1.BUSINESSDAYSSINCE <= u.sla
    THEN 1
    ELSE 0
  END ) WithinSLA,
    (
  CASE
    WHEN bds2.BUSINESSDAYSSINCE - bds1.BUSINESSDAYSSINCE <= u.sla
    THEN null
    ELSE bds2.BUSINESSDAYSSINCE - bds1.BUSINESSDAYSSINCE - u.sla
  END ) BDOverdue
FROM UNINSPECTED_SERV_REQ u,
  BUSINESS_DAYS_SINCE_2016 bds1,
  BUSINESS_DAYS_SINCE_2016 bds2
WHERE TO_DATE(TO_CHAR(u.calldate, 'mm')
  || TO_CHAR(u.calldate, 'dd')
  || TO_CHAR(u.calldate, 'yyyy'), 'MMDDYYYY') = bds1.DATEOFYEAR (+)
AND TO_DATE(TO_CHAR(SYSDATE, 'mm')
  || TO_CHAR(SYSDATE, 'dd')
  || TO_CHAR(SYSDATE, 'yyyy'), 'MMDDYYYY') = bds2.DATEOFYEAR (+)