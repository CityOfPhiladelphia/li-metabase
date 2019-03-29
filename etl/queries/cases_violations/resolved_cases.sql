SELECT c.apno,
  c.adddttm,
  c.rescode,
  c.RESDTTM,
  c.casegrp,
  c.apkey,
  i.apkey,
  i.apinspkey,
  i.SCHEDDTTM,
  i.compdttm,
  DECODE(i.stat, 0, 'None', 1, 'Passed', 2, 'Failed', 3, 'Cancelled', 4, 'HOLD', 5, 'Closed') InspectionStatus,
	e.empfirst || ' ' || e.emplast inspectorname
FROM imsv7.apcase c,
  imsv7.apinsp i,
  imsv7.employee e
WHERE c.apkey  = i.apkey (+)
AND i.assignto = e.empid (+)
AND c.rescode is not null 
AND c.resdttm is not null
AND c.adddttm >= '1-MAR-2019'
AND c.adddttm  < SYSDATE - 1
