SELECT DISTINCT TRIM(c.apno) casenumber,
  c.adddttm caseaddeddate,
  c.casegrp casegroup,
  i.assignto,
  (
  CASE
    WHEN e.empfirst IS NULL
    AND e.emplast   IS NULL
    THEN '(none)'
    ELSE e.empfirst
      || ' '
      || e.emplast
  END ) inspectorname,
  a.council CouncilDistrict,
  lni_addr.OPS_DISTRICT OpsDistrict,
  a.C_TRACT CensusTract
FROM imsv7.apcase@lidb_link c,
  imsv7.apinsp@lidb_link i,
  imsv7.employee@lidb_link e,
  imsv7.address@lidb_link a,
  lni_addr
WHERE c.apkey  = i.apkey (+)
AND i.assignto = e.empid (+)
AND c.addrkey = a.addrkey (+)
AND c.addrkey = lni_addr.addrkey (+)