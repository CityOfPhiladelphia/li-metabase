SELECT c.casenumber,
  c.caseaddeddate,
  c.caseresolutioncode,
  c.completeddate, --same as old caseresolutiondate?
  c.caseresponsibility, --replacement for casegroup
  c.LastCompletedInv,
  c.LastCompletedInvStatus,
  c.LastCompletedInvInvestigator,
  c.NextScheduledInv,
  c.NextScheduledInvInvestigator,
  c.OverdueInvScheduledDate,
  c.OverdueInvInvestigator,
  c.zip,
  c.council_district,
  c.li_district,
  c.census_tract_2010,
  c.casecompleteddatehasvalue,
  c.FirstCompletedInv,
  c.FirstCompletedInvStatus,
  c.FirstCompletedInvInvestigator
FROM CASES_MVW c
WHERE c.caseaddeddate < add_months(TRUNC(SYSDATE, 'MM'),-60)
AND (c.caseresolutioncode is null or c.completeddate is null)
