SELECT j.jobid,
  proc.processid,
  REPLACE(jt.description, 'Business License ', '') JobType,
  ap.createddate JobCreatedDateField,
  proc.datecompleted ProcessDateCompletedField
FROM api.processes PROC,
  api.processtypes pt,
  api.jobs j,
  api.jobtypes jt,
  query.j_bl_application ap
WHERE proc.jobid       = j.jobid
AND j.jobid            = ap.jobid
AND proc.processtypeid = pt.processtypeid
AND j.jobtypeid        = jt.jobtypeid
AND ap.createddate     > add_months(TRUNC(SYSDATE, 'MM'),-13)
AND ap.createddate     < SYSDATE
AND pt.processtypeid LIKE '1239327'
UNION
SELECT j.jobid,
  proc.processid,
  jt.description JobType,
  ar.createddate JobCreatedDateField,
  proc.datecompleted ProcessDateCompletedField
FROM api.processes PROC,
  api.processtypes pt,
  api.jobs j,
  api.jobtypes jt,
  query.j_bl_amendrenew ar
WHERE proc.jobid       = j.jobid
AND j.jobid            = ar.jobid
AND proc.processtypeid = pt.processtypeid
AND j.jobtypeid        = jt.jobtypeid
AND ar.createddate     > add_months(TRUNC(SYSDATE, 'MM'),-13)
AND ar.createddate     < SYSDATE
AND pt.processtypeid LIKE '1239327'
