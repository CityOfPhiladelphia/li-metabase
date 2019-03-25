SELECT DISTINCT 
  j.externalfilenum JobNumber,
  ap.LICENSETYPESDISPLAYFORMAT LicenseType,
  REPLACE(jt.description, 'Business License ', '') JobType,
  ap.createddate JobCreatedDate,
  stat.description JobStatus,
  proc.processstatus CompletenessCheckStatus,
  proc.datecompleted CompletenessCheckCompleted,
  (
  CASE
    WHEN jt.description LIKE 'Business License Application'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1239699&objectHandle='
      ||j.jobid
      ||'&processHandle='
    WHEN jt.description LIKE 'Amendment/Renewal'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1243107&objectHandle='
      ||j.jobid
      ||'&processHandle='
  END ) JobLink
FROM api.processes PROC,
  api.processtypes pt,
  api.jobs j,
  api.statuses stat,
  api.jobtypes jt,
  query.j_bl_application ap
WHERE j.jobid           = proc.jobid
AND proc.processtypeid  = pt.processtypeid
AND j.jobtypeid         = jt.jobtypeid
AND j.jobid             = ap.jobid
AND j.statusid          = stat.statusid
AND ap.createddate      > add_months(TRUNC(SYSDATE, 'MM'),-13)
AND ap.createddate      < TO_DATE(TO_CHAR(sysdate, 'MM/DD/YYYY'), 'MM/DD/YYYY')
AND pt.processtypeid LIKE '1239327'
UNION
SELECT DISTINCT 
  j.externalfilenum JobNumber,
  ar.LICENSETYPESDISPLAYFORMAT LicenseType,
  jt.description JobType,
  ar.createddate JobCreatedDate,
  stat.description JobStatus,
  proc.processstatus CompletenessCheckStatus,
  proc.datecompleted CompletenessCheckCompleted,
  (
  CASE
    WHEN jt.description LIKE 'Business License Application'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1239699&objectHandle='
      ||j.jobid
      ||'&processHandle='
    WHEN jt.description LIKE 'Amendment/Renewal'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1243107&objectHandle='
      ||j.jobid
      ||'&processHandle='
  END ) JobLink
FROM api.processes PROC,
  api.processtypes pt,
  api.jobs j,
  api.statuses stat,
  api.jobtypes jt,
  query.j_bl_amendrenew ar
WHERE j.jobid          = proc.jobid
AND proc.processtypeid = pt.processtypeid
AND j.jobtypeid        = jt.jobtypeid
AND j.jobid            = ar.jobid
AND j.statusid         = stat.statusid
AND ar.createddate     > add_months(TRUNC(SYSDATE, 'MM'),-13)
AND ar.createddate     < TO_DATE(TO_CHAR(sysdate, 'MM/DD/YYYY'), 'MM/DD/YYYY')
AND pt.processtypeid LIKE '1239327'
