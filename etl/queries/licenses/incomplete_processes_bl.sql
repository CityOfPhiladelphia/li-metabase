SELECT proc.processid,
  pt.description ProcessType,
  j.ExternalFileNum JobNumber,
  REPLACE(jt.description, 'Business License ', '') JobType,
  (
  CASE
    WHEN ap.licensetypesdisplayformat IS NOT NULL
    THEN ap.licensetypesdisplayformat
    ELSE '(none)'
  END ) LicenseType,
  (
  CASE
    WHEN proc.ASSIGNEDSTAFF IS NULL
    THEN '(none)'
    WHEN regexp_count(proc.ASSIGNEDSTAFF, ',') = 0
    THEN proc.ASSIGNEDSTAFF
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
    WHEN jt.description LIKE 'Business License Application'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1239699&objectHandle='
      ||j.jobid
      ||'&processHandle='
      ||proc.processid
      ||'&paneId=1239699_151'
  END ) JobLink,
  stat.description JobStatus
FROM api.processes PROC,
  api.processtypes pt,
  api.jobs j,
  api.jobtypes jt,
  api.statuses stat,
  query.j_bl_application ap
WHERE proc.jobid             = j.jobid
AND j.jobid                  = ap.jobid
AND proc.processtypeid       = pt.processtypeid
AND j.jobtypeid              = jt.jobtypeid
AND j.statusid               = stat.statusid
AND proc.datecompleted      IS NULL
UNION
SELECT proc.processid,
  pt.description ProcessType,
  j.ExternalFileNum JobNumber,
  REPLACE(REPLACE(jt.description, 'Business License ', ''), 'Amendment/Renewal', 'Amend/Renew') JobType,
  (
  CASE
    WHEN ar.licensetypesdisplayformat IS NOT NULL
    THEN ar.licensetypesdisplayformat
    ELSE '(none)'
  END ) LicenseType,
  (
  CASE
    WHEN proc.ASSIGNEDSTAFF IS NULL
    THEN '(none)'
    WHEN regexp_count(proc.ASSIGNEDSTAFF, ',') = 0
    THEN proc.ASSIGNEDSTAFF
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
    WHEN jt.description LIKE 'Amendment/Renewal'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1243107&objectHandle='
      ||j.jobid
      ||'&processHandle='
      ||proc.processid
      ||'&paneId=1243107_175'
  END ) JobLink,
  stat.description JobStatus
FROM api.processes PROC,
  api.processtypes pt,
  api.jobs j,
  api.jobtypes jt,
  api.statuses stat,
  query.j_bl_amendrenew ar
WHERE proc.jobid             = j.jobid
AND j.jobid                  = ar.jobid
AND proc.processtypeid       = pt.processtypeid
AND j.jobtypeid              = jt.jobtypeid
AND j.statusid               = stat.statusid
AND proc.datecompleted      IS NULL