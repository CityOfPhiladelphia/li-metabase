SELECT DISTINCT j.externalfilenum JobNumber,
  REPLACE(jt.description, 'Trade License ', '') JobType,
  NVL(lt.description, apl.licensetype) LicenseType,
  stat.description JobStatus,
  proc.processid ProcessID,
  pt.description ProcessType,
  Extract(MONTH FROM proc.createddate)
  || '/'
  ||Extract(DAY FROM proc.createddate)
  || '/'
  || Extract(YEAR FROM proc.createddate) CreatedDate,
  Extract(MONTH FROM proc.scheduledstartdate)
  || '/'
  || Extract(DAY FROM proc.scheduledstartdate)
  || '/'
  ||Extract(YEAR FROM proc.scheduledstartdate) ScheduledStartDate,
  proc.processstatus ProcessStatus,
  (CASE
    WHEN ROUND(SYSDATE - proc.scheduledstartdate) <= 1
    THEN '0-1 Day'
    WHEN ROUND(SYSDATE - proc.scheduledstartdate) BETWEEN 2 AND 5
    THEN '2-5 Days'
    WHEN ROUND(SYSDATE - proc.scheduledstartdate) BETWEEN 6 AND 10
    THEN '6-10 Days'
    WHEN ROUND(SYSDATE - proc.scheduledstartdate) BETWEEN 11 AND 365
    THEN '11 Days-1 Year'
    ELSE 'Over 1 Year'
  END) Duration,
  (CASE
    WHEN jt.description LIKE 'Trade License Application'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=2854033&objectHandle='
      ||j.jobid
      ||'&processHandle='
      ||proc.processid
      ||'&paneId=2854033_116'
    WHEN jt.description LIKE 'Trade License Amend/Renew'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=2857688&objectHandle='
      ||j.jobid
      ||'&processHandle='
      ||proc.processid
      ||'&paneId=2857688_87'
  END ) ProcessLink
FROM api.processes PROC,
  api.jobs j,
  api.processtypes pt,
  api.jobtypes jt,
  api.statuses stat,
  query.r_tl_amendrenew_license arl,
  query.o_tl_license lic,
  query.o_tl_licensetype lt,
  query.j_tl_application apl
WHERE proc.jobid          = j.jobid
AND proc.processtypeid    = pt.processtypeid
AND proc.datecompleted   IS NULL
AND j.jobtypeid           = jt.jobtypeid
AND j.statusid            = stat.statusid
AND pt.processtypeid NOT IN ( '984507', '2852606', '2853029' )
AND jt.jobtypeid         IN ( '2853921', '2857525' )
AND j.statusid NOT       IN ( '1030266', '964970', '1014809', '1036493', '1010379' )
AND j.jobid               = arl.amendrenewid (+)
AND arl.licenseid         = lic.objectid (+)
AND lic.revenuecode       = lt.revenuecode (+)
AND j.jobid               = apl.objectid (+)
