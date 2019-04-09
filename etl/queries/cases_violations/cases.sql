SELECT c.apno casenumber,
  c.adddttm caseaddeddate,
  (
  CASE
    WHEN c.rescode IS NULL
    THEN '(none)'
    ELSE c.rescode
  END ) caseresolutioncode,
  c.RESDTTM caseresolutiondate,
  c.casegrp casegroup,
  lci.compdttm LastCompletedInsp,
  DECODE(lci.stat, 0, 'None', 1, 'Passed', 2, 'Failed', 3, 'Cancelled', 4, 'HOLD', 5, 'Closed') LastCompletedInspStatus,
  (
  CASE
    WHEN lci.inspectorname IS NULL
    THEN '(none)'
    ELSE lci.inspectorname
  END ) LastCompletedInspInspector,
  nsi.SCHEDDTTM NextScheduledInsp,
  (
  CASE
    WHEN nsi.inspectorname IS NULL
    THEN '(none)'
    ELSE nsi.inspectorname
  END ) NextScheduledInspInspector,  
  ovdi.SCHEDDTTM OverdueInspScheduledDate,
  (
  CASE
    WHEN ovdi.inspectorname IS NULL
    THEN '(none)'
    ELSE ovdi.inspectorname
  END ) OverdueInspInspector,
  a.C_TRACT CensusTract,
  (
  CASE
    WHEN a.zip IS NULL
    THEN '(none)'
    ELSE a.zip
  END ) zip,
  a.council CouncilDistrict,
  lni_addr.OPS_DISTRICT OpsDistrict
FROM imsv7.apcase@lidb_link c,
  (SELECT *
  FROM
    (SELECT RANK() OVER (PARTITION BY i.apkey ORDER BY i.compdttm DESC NULLS LAST) AS RankCompDttm,
      i.apkey,
      i.SCHEDDTTM,
      i.compdttm,
      i.stat,
      (
      CASE
        WHEN e.empfirst IS NULL
        AND e.emplast   IS NULL
        THEN '(none)'
        ELSE e.empfirst
          || ' '
          || e.emplast
      END ) inspectorname
    FROM imsv7.apinsp@lidb_link i,
      imsv7.employee@lidb_link e
    WHERE i.assignto = e.empid (+)
    AND i.compdttm  IS NOT NULL
    )
  WHERE RankCompDttm = 1
  ) lci,
  (SELECT *
  FROM
    (SELECT RANK() OVER (PARTITION BY i.apkey ORDER BY i.SCHEDDTTM ASC NULLS LAST) AS RankSchedDttm,
      i.apkey,
      i.SCHEDDTTM,
      (
      CASE
        WHEN e.empfirst IS NULL
        AND e.emplast   IS NULL
        THEN '(none)'
        ELSE e.empfirst
          || ' '
          || e.emplast
      END ) inspectorname
    FROM imsv7.apinsp@lidb_link i,
      imsv7.employee@lidb_link e
    WHERE i.assignto = e.empid (+)
    AND i.SCHEDDTTM > SYSDATE
    )
  WHERE RankSchedDttm = 1
  ) nsi,
  (SELECT *
  FROM
    (SELECT RANK() OVER (PARTITION BY i.apkey ORDER BY i.SCHEDDTTM ASC NULLS LAST) AS RankSchedDttm,
      i.apkey,
      i.SCHEDDTTM,
      (
      CASE
        WHEN e.empfirst IS NULL
        AND e.emplast   IS NULL
        THEN '(none)'
        ELSE e.empfirst
          || ' '
          || e.emplast
      END ) inspectorname
    FROM imsv7.apinsp@lidb_link i,
      imsv7.employee@lidb_link e
    WHERE i.assignto = e.empid (+)
    AND i.SCHEDDTTM  < SYSDATE
    AND i.compdttm  IS NULL
    )
  WHERE RankSchedDttm = 1
  ) ovdi,
  imsv7.address@lidb_link a,
  lni_addr
WHERE c.apkey   = lci.apkey (+)
AND c.apkey     = nsi.apkey (+)
AND c.apkey     = ovdi.apkey (+)
AND c.addrkey   = a.addrkey
AND c.addrkey   = lni_addr.addrkey (+)
AND (c.RESDTTM IS NULL
OR c.RESDTTM   >= DATE '2018-1-1')
AND c.adddttm   < TO_DATE(TO_CHAR(SYSDATE,'MM/DD/YYYY'),'MM/DD/YYYY')