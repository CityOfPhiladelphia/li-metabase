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
  c.FirstCompletedInvInvestigator,
  (
  CASE
    WHEN cases_with_only_license_vios.casenumber IS NOT NULL
    THEN 'Yes'
    ELSE 'No'
  END) OnlyIncludesLicenseVios
FROM CASES_MVW c,
  ( SELECT DISTINCT casenumber
  FROM VIOLATIONS_MVW
  WHERE (VIOLATIONTYPE IN ('9-3902 (1)','9-3902 (2)','9-3902 (3)','9-3902 (4)','9-3904','9-3905')
  OR VIOLATIONTYPE NOT LIKE 'PM-102%')
  AND CASEADDEDDATE >= add_months(TRUNC(SYSDATE, 'MM'),-60)
  AND CASEADDEDDATE  < TO_DATE(TO_CHAR(SYSDATE,'MM/DD/YYYY'),'MM/DD/YYYY')
  MINUS
  SELECT DISTINCT casenumber
  FROM VIOLATIONS_MVW
  WHERE VIOLATIONTYPE NOT IN ('9-3902 (1)','9-3902 (2)','9-3902 (3)','9-3902 (4)','9-3904','9-3905')
  AND VIOLATIONTYPE NOT LIKE 'PM-102%'
  AND CASEADDEDDATE >= add_months(TRUNC(SYSDATE, 'MM'),-60)
  AND CASEADDEDDATE  < TO_DATE(TO_CHAR(SYSDATE,'MM/DD/YYYY'),'MM/DD/YYYY')
  ) cases_with_only_license_vios
WHERE c.casenumber   = cases_with_only_license_vios.casenumber (+)
AND c.caseaddeddate >= add_months(TRUNC(SYSDATE, 'MM'),-60)
AND c.caseaddeddate  < TO_DATE(TO_CHAR(SYSDATE,'MM/DD/YYYY'),'MM/DD/YYYY')