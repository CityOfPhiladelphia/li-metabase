SELECT proc.processid,
  pt.description ProcessType,
  j.ExternalFileNum JobNumber,
  REPLACE(jt.description, 'Trade License ', '') JobType,
  (
  CASE
    WHEN lt.title IS NOT NULL
    THEN lt.title
    ELSE '(none)'
  END ) LicenseType,
  (
  CASE
    WHEN proc.ASSIGNEDSTAFF IS NULL
    THEN '(none)'
    ELSE 'multiple'
  END ) ASSIGNEDSTAFF,
  (
  CASE
    WHEN regexp_count(proc.ASSIGNEDSTAFF, ',') IS NULL
    THEN 0
    ELSE regexp_count(proc.ASSIGNEDSTAFF, ',') + 1
  END ) NUMASSIGNEDSTAFF,
  proc.scheduledstartdate ScheduledStartDate,
  SYSDATE - proc.scheduledstartdate TimeSinceScheduledStartDate,
  (
  CASE
    WHEN jt.description LIKE 'Trade License Application'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=2854033&objectHandle='
      ||j.jobid
      ||'&processHandle='
      ||proc.processid
      ||'&paneId=2854033_116'
  END ) JobLink,
  stat.description JobStatus
FROM api.processes PROC,
  api.processtypes pt,
  api.jobs j,
  api.jobtypes jt,
  api.statuses stat,
  query.j_tl_application ap,
  query.r_tllicensetype lrl,
  query.o_tl_licensetype lt
WHERE proc.jobid            = j.jobid
AND j.jobid                 = ap.objectid
AND ap.tradelicenseobjectid = lrl.licenseobjectid (+)
AND lrl.licensetypeobjectid = lt.objectid (+)
AND proc.processtypeid      = pt.processtypeid
AND j.jobtypeid             = jt.jobtypeid
AND j.statusid              = stat.statusid
AND proc.datecompleted     IS NULL
AND (proc.ASSIGNEDSTAFF    IS NULL
OR regexp_count(proc.ASSIGNEDSTAFF, ',') > 0)
UNION
SELECT proc.processid,
    pt.description ProcessType,
    j.ExternalFileNum JobNumber,
    REPLACE(jt.description, 'Trade License ', '') JobType,
  (
  CASE
    WHEN lt.title IS NOT NULL
    THEN lt.title
    ELSE '(none)'
  END ) LicenseType,
  INITCAP(regexp_replace(REPLACE(u.name, '  ', ' '), '[0-9]', '')) ASSIGNEDSTAFF,
  1 NUMASSIGNEDSTAFF,
  proc.scheduledstartdate ScheduledStartDate,
  SYSDATE - proc.scheduledstartdate TimeSinceScheduledStartDate,
  (
  CASE
    WHEN jt.description LIKE 'Trade License Application'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=2854033&objectHandle='
      ||j.jobid
      ||'&processHandle='
      ||proc.processid
      ||'&paneId=2854033_116'
  END ) JobLink,
  stat.description JobStatus
FROM api.processes PROC,
  api.processtypes pt,
  api.jobs j,
  api.jobtypes jt,
  api.statuses stat,
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
AND j.statusid              = stat.statusid
AND proc.assignedstaff      = u.oraclelogonid
AND (proc.datecompleted     IS NULL
OR regexp_count(proc.ASSIGNEDSTAFF, ',') > 0)
UNION
SELECT proc.processid,
  pt.description ProcessType,
  j.ExternalFileNum JobNumber,
  REPLACE(jt.description, 'Trade License ', '') JobType,
  (
  CASE
    WHEN lt.title IS NOT NULL
    THEN lt.title
    ELSE '(none)'
  END ) LicenseType,
  (
  CASE
    WHEN proc.ASSIGNEDSTAFF IS NULL
    THEN '(none)'
    ELSE 'multiple'
  END ) ASSIGNEDSTAFF,
  (
  CASE
    WHEN regexp_count(proc.ASSIGNEDSTAFF, ',') IS NULL
    THEN 0
    ELSE regexp_count(proc.ASSIGNEDSTAFF, ',') + 1
  END ) NUMASSIGNEDSTAFF,
  proc.scheduledstartdate ScheduledStartDate,
  SYSDATE - proc.scheduledstartdate TimeSinceScheduledStartDate,
  (
  CASE
    WHEN jt.description LIKE 'Trade License Amend/Renew'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=2857688&objectHandle='
      ||j.jobid
      ||'&processHandle='
      ||proc.processid
      ||'&paneId=2857688_87'
  END ) JobLink,
  stat.description JobStatus
FROM api.processes PROC,
  api.processtypes pt,
  api.jobs j,
  api.jobtypes jt,
  api.statuses stat,
  query.j_tl_amendrenew ar,
  query.r_tl_amendrenew_license arl,
  query.r_tllicensetype lrl,
  query.o_tl_licensetype lt
WHERE proc.jobid            = j.jobid
AND j.externalfilenum       = ar.externalfilenum
AND ar.objectid             = arl.amendrenewid (+)
AND arl.licenseid           = lrl.licenseobjectid (+)
AND lrl.licensetypeobjectid = lt.objectid (+)
AND proc.processtypeid      = pt.processtypeid
AND j.jobtypeid             = jt.jobtypeid
AND j.statusid              = stat.statusid
AND proc.datecompleted     IS NULL
AND (proc.ASSIGNEDSTAFF    IS NULL
OR regexp_count(proc.ASSIGNEDSTAFF,',') > 0)
UNION
SELECT proc.processid,
  pt.description ProcessType,
  j.ExternalFileNum JobNumber,
  REPLACE(jt.description, 'Trade License ', '') JobType,
  (
  CASE
    WHEN lt.title IS NOT NULL
    THEN lt.title
    ELSE '(none)'
  END ) LicenseType,
  INITCAP(regexp_replace(REPLACE(u.name, '  ', ' '), '[0-9]', '')) ASSIGNEDSTAFF,
  1 NUMASSIGNEDSTAFF,
  proc.scheduledstartdate ScheduledStartDate,
  SYSDATE - proc.scheduledstartdate TimeSinceScheduledStartDate,
  (
  CASE
    WHEN jt.description LIKE 'Trade License Amend/Renew'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=2857688&objectHandle='
      ||j.jobid
      ||'&processHandle='
      ||proc.processid
      ||'&paneId=2857688_87'
  END ) JobLink,
  stat.description JobStatus
FROM api.processes PROC,
  api.processtypes pt,
  api.jobs j,
  api.jobtypes jt,
  api.statuses stat,
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
AND j.statusid              = stat.statusid
AND proc.assignedstaff      = u.oraclelogonid
AND proc.datecompleted     IS NULL
AND regexp_count(proc.ASSIGNEDSTAFF, ',') = 0