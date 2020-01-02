SELECT c.casenumber,
  c.caseaddeddate,
  c.caseresolutioncode,
  c.caseresolutiondate,
  c.casegroup,
  c.LastCompletedInsp,
  c.LastCompletedInspStatus,
  c.LastCompletedInspInspector,
  c.NextScheduledInsp,
  c.NextScheduledInspInspector,
  c.OverdueInspScheduledDate,
  c.OverdueInspInspector,
  c.zip,
  c.CouncilDistrict,
  c.OpsDistrict,
  c.CensusTract,
  c.caseresolutiondatehasvalue,
  c.FirstCompletedInsp,
  c.FirstCompletedInspStatus,
  c.FirstCompletedInspInspector
FROM CASES_MVW c
WHERE c.caseaddeddate < add_months(TRUNC(SYSDATE, 'MM'),-60)
AND (c.caseresolutioncode is null or c.caseresolutiondate is null)
