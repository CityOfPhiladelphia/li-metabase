SELECT DISTINCT TRIM(c.apno) casenumber,
  c.adddttm caseaddeddate,
  c.casegrp casegroup,
  a.council CouncilDistrict,
  lni_addr.OPS_DISTRICT OpsDistrict,
  a.C_TRACT CensusTract,
  sup_log.logtype,
  sup_log.enteredby,
  sup_log.enteredbyname,
  sup_log.startdttm logstartdate,
  sup_log.comments
FROM imsv7.apcase@lidb_link c,
  (SELECT r.apkey,
    r.logtype,
    r.enteredby,
    (
    CASE
      WHEN (e.empfirst IS NOT NULL
      OR e.emplast     IS NOT NULL)
      THEN e.empfirst
        || ' '
        || e.emplast
    END ) enteredbyname,
    r.startdttm,
    r.comments
  FROM imsv7.aprec@lidb_link r,
    imsv7.employee@lidb_link e
  WHERE r.enteredby = e.empid
  AND (r.logtype    = 'CNE'
  OR r.logtype      = 'COMMNT'
  OR r.logtype      = 'ICEASE')
  ) sup_log,
  imsv7.address@lidb_link a,
  lni_addr
WHERE c.apkey = sup_log.apkey (+)
AND c.addrkey = a.addrkey (+)
AND c.addrkey = lni_addr.addrkey (+)