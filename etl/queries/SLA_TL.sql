SELECT j.jobid,
  proc.processid,
  REPLACE(jt.description, 'Trade License ', '') JobType,
  ap.createddate JobCreatedDateField,
  proc.datecompleted ProcessDateCompletedField
FROM api.processes PROC,
  api.processtypes pt,
  api.jobs j,
  api.jobtypes jt,
  query.j_tl_application ap
WHERE proc.jobid       = j.jobid
AND j.jobid            = ap.jobid
AND proc.processtypeid = pt.processtypeid
AND j.jobtypeid        = jt.jobtypeid
AND ap.createddate     > add_months(TRUNC(SYSDATE, 'MM'),-13)
AND ap.createddate     < SYSDATE
AND pt.processtypeid   IN( '2851903', '2854108', '2852692', '2852680', '2854639', '2853029', '2854845', '2855079' )
UNION
SELECT j.jobid,
  proc.processid,
  REPLACE(jt.description, 'Trade License ', '') JobType,
  ar.createddate JobCreatedDateField,
  proc.datecompleted ProcessDateCompletedField
FROM api.processes PROC,
  api.processtypes pt,
  api.jobs j,
  api.jobtypes jt,
  query.j_tl_amendrenew ar,
  query.r_tl_amendrenew_license arl
WHERE proc.jobid       = j.jobid
AND j.externalfilenum  = ar.externalfilenum
AND ar.objectid        = arl.amendrenewid
AND proc.processtypeid = pt.processtypeid
AND j.jobtypeid        = jt.jobtypeid
AND ar.createddate     > add_months(TRUNC(SYSDATE, 'MM'),-13)
AND ar.createddate     < SYSDATE
AND pt.processtypeid   IN( '2851903', '2854108', '2852692', '2852680', '2854639', '2853029', '2854845', '2855079' )