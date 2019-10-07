SELECT proc.processid,  --lmscorral.processes.processid
  pt.description ProcessType,  --???
  j.ExternalFileNum JobNumber,  --lmscorral.bl_alljobs.externalfilenum
  REPLACE(jt.description, 'Business License ', '') JobType,  --???
  'Business' LicenseKind,
  (
  CASE
    WHEN ap.licensetypesdisplayformat IS NOT NULL  --lmscorral.bl_licensetype via bl_license via ???
    THEN ap.licensetypesdisplayformat
    ELSE '(none)'
  END ) LicenseType,
  INITCAP(u.name) Person,  --lmscorral.users.firstname || lmscorral.users.firstname
  proc.scheduledstartdate,  --lmscorral.processes.ScheduledStartDate
  proc.datecompleted,  --lmscorral.processes.datecompleted
  proc.datecompleted - proc.scheduledstartdate AS duration,
  (
  CASE
    WHEN jt.description LIKE 'Business License Application'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1239699&objectHandle='
      ||j.jobid  --lmscorral.bl_alljobs.jobid
      ||'&processHandle=&paneId=1239699_151'
  END ) JobLink
FROM api.processes PROC,
  api.processtypes pt,
  api.jobs j,
  api.jobtypes jt,
  query.j_bl_application ap,
  api.users u
WHERE proc.jobid           = j.jobid
AND j.jobid                = ap.jobid
AND proc.processtypeid     = pt.processtypeid
AND j.jobtypeid            = jt.jobtypeid
AND proc.completedbyuserid = u.userid
AND proc.datecompleted     > add_months(TRUNC(SYSDATE, 'MM'),-36)
AND proc.datecompleted     < SYSDATE
AND regexp_like(u.name, '[A-Za-z\s]+$')
AND u.name <> 'PPG User'
AND u.name <> 'POSSE system power user'
UNION
SELECT proc.processid,
  pt.description ProcessType,
  j.ExternalFileNum JobNumber,
  REPLACE(REPLACE(jt.description, 'Business License ', ''), 'Amendment/Renewal', 'Amend/Renew') JobType,
  'Business' LicenseKind,
  (
  CASE
    WHEN ar.licensetypesdisplayformat IS NOT NULL
    THEN ar.licensetypesdisplayformat
    ELSE '(none)'
  END ) LicenseType,
  INITCAP(u.name) Person,
  proc.scheduledstartdate,
  proc.datecompleted,
  proc.datecompleted - proc.scheduledstartdate AS duration,
  (
  CASE
    WHEN jt.description LIKE 'Amendment/Renewal'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1243107&objectHandle='
      ||j.jobid
      ||'&processHandle=&paneId=1243107_175'
  END ) JobLink
FROM api.processes PROC,
  api.processtypes pt,
  api.jobs j,
  api.jobtypes jt,
  query.j_bl_amendrenew ar,
  api.users u
WHERE proc.jobid           = j.jobid
AND j.jobid                = ar.jobid
AND proc.processtypeid     = pt.processtypeid
AND j.jobtypeid            = jt.jobtypeid
AND proc.completedbyuserid = u.userid
AND proc.datecompleted     > add_months(TRUNC(SYSDATE, 'MM'),-36)
AND proc.datecompleted     < SYSDATE
AND regexp_like(u.name, '[A-Za-z\s]+$')
AND u.name <> 'PPG User'
AND u.name <> 'POSSE system power user'
UNION
SELECT proc.processid,
  pt.description ProcessType,
  j.ExternalFileNum JobNumber,
  REPLACE(jt.description, 'Trade License ', '') JobType,
  'Trade' LicenseKind,
  (
  CASE
    WHEN lt.title IS NOT NULL
    THEN lt.title
    ELSE '(none)'
  END ) LicenseType,
  INITCAP(u.name) Person,
  proc.scheduledstartdate,
  proc.datecompleted,
  proc.datecompleted - proc.scheduledstartdate AS duration,
  (
  CASE
    WHEN jt.description LIKE 'Trade License Application'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=2854033&objectHandle='
      ||j.jobid
      ||'&processHandle=&paneId=2854033_140'
  END ) JobLink
FROM api.processes PROC,
  api.processtypes pt,
  api.jobs j,
  api.jobtypes jt,
  query.j_tl_application ap,
  query.r_tllicensetype lrl,
  query.o_tl_licensetype lt,
  api.users u
WHERE proc.jobid            = j.jobid
AND j.jobid                 = ap.objectid
AND ap.tradelicenseobjectid = lrl.licenseobjectid (+)
AND lrl.licensetypeobjectid = lt.objectid (+)
AND proc.processtypeid      = pt.processtypeid
AND j.jobtypeid             = jt.jobtypeid
AND proc.completedbyuserid  = u.userid
AND proc.datecompleted      > add_months(TRUNC(SYSDATE, 'MM'),-36)
AND proc.datecompleted      < SYSDATE
AND regexp_like(u.name, '[A-Za-z\s]+$')
AND u.name <> 'PPG User'
AND u.name <> 'POSSE system power user'
UNION
SELECT proc.processid,
  pt.description ProcessType,
  j.ExternalFileNum JobNumber,
  REPLACE(jt.description, 'Trade License ', '') JobType,
  'Trade' LicenseKind,
  (
  CASE
    WHEN lt.title IS NOT NULL
    THEN lt.title
    ELSE '(none)'
  END ) LicenseType,
  INITCAP(u.name) Person,
  proc.scheduledstartdate,
  proc.datecompleted,
  proc.datecompleted - proc.scheduledstartdate AS duration,
  (
  CASE
    WHEN jt.description LIKE 'Trade License Amend/Renew'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=2857688&objectHandle='
      ||j.jobid
      ||'&processHandle=&paneId=2857688_106'
  END ) JobLink
FROM api.processes PROC,
  api.processtypes pt,
  api.jobs j,
  api.jobtypes jt,
  query.j_tl_amendrenew ar,
  query.r_tl_amendrenew_license arl,
  query.r_tllicensetype lrl,
  query.o_tl_licensetype lt,
  api.users u
WHERE proc.jobid            = j.jobid
AND j.externalfilenum       = ar.externalfilenum
AND ar.objectid             = arl.amendrenewid (+)
AND arl.licenseid           = lrl.licenseobjectid (+)
AND lrl.licensetypeobjectid = lt.objectid (+)
AND proc.processtypeid      = pt.processtypeid
AND j.jobtypeid             = jt.jobtypeid
AND proc.completedbyuserid  = u.userid
AND proc.datecompleted      > add_months(TRUNC(SYSDATE, 'MM'),-36)
AND proc.datecompleted      < SYSDATE
AND regexp_like(u.name, '[A-Za-z\s]+$')
AND u.name <> 'PPG User'
AND u.name <> 'POSSE system power user'