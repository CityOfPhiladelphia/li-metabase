SELECT proc.processid,
  pt.description ProcessType,
  j.ExternalFileNum JobNumber,  
  REPLACE(jt.description, 'Business License ', '') JobType,
  ap.licensetypesdisplayformat LicenseType,
  (CASE
    WHEN proc.ASSIGNEDSTAFF IS NULL
    THEN NULL
    WHEN regexp_count(proc.ASSIGNEDSTAFF, ',') = 0
    THEN proc.ASSIGNEDSTAFF
    ELSE 'multiple'
  END ) ASSIGNEDSTAFF,
  (CASE
    WHEN regexp_count(proc.ASSIGNEDSTAFF, ',') IS NULL
    THEN 0
    ELSE regexp_count(proc.ASSIGNEDSTAFF, ',') + 1
  END ) NUMASSIGNEDSTAFF,
  Extract(month FROM proc.scheduledstartdate) || '/' ||Extract(day FROM proc.scheduledstartdate) || '/' || Extract(year FROM proc.scheduledstartdate) ScheduledStartDate,
  proc.scheduledstartdate ScheduledStartDateField,
  SYSDATE - proc.scheduledstartdate TimeSinceScheduledStartDate,
 (CASE
    WHEN jt.description LIKE 'Business License Application'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1239699&objectHandle='
      ||j.jobid
      ||'&processHandle='
      ||proc.processid
      ||'&paneId=1239699_151'
  END ) JobLink
FROM api.processes PROC,
  api.processtypes pt,
  api.jobs j,
  api.jobtypes jt,
  query.j_bl_application ap
WHERE proc.jobid           = j.jobid
AND j.jobid                = ap.jobid
AND proc.processtypeid     = pt.processtypeid
AND j.jobtypeid            = jt.jobtypeid
AND proc.datecompleted     IS NULL
UNION
SELECT proc.processid,
  pt.description ProcessType,
  j.ExternalFileNum JobNumber,  
  REPLACE(REPLACE(jt.description, 'Business License ', ''), 'Amendment/Renewal', 'Amend/Renew') JobType,
  ar.licensetypesdisplayformat LicenseType,
  (CASE
    WHEN proc.ASSIGNEDSTAFF IS NULL
    THEN NULL
    WHEN regexp_count(proc.ASSIGNEDSTAFF, ',') = 0
    THEN proc.ASSIGNEDSTAFF
    ELSE 'multiple'
  END ) ASSIGNEDSTAFF,
  (CASE
    WHEN regexp_count(proc.ASSIGNEDSTAFF, ',') IS NULL
    THEN 0
    ELSE regexp_count(proc.ASSIGNEDSTAFF, ',') + 1
  END ) NUMASSIGNEDSTAFF,
  Extract(month FROM proc.scheduledstartdate) || '/' ||Extract(day FROM proc.scheduledstartdate) || '/' || Extract(year FROM proc.scheduledstartdate) ScheduledStartDate,
  proc.scheduledstartdate ScheduledStartDateField,
  SYSDATE - proc.scheduledstartdate TimeSinceScheduledStartDate,
    (
  CASE
    WHEN jt.description LIKE 'Amendment/Renewal'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1243107&objectHandle='
      ||j.jobid
      ||'&processHandle='
      ||proc.processid
      ||'&paneId=1243107_175'
  END ) JobLink
FROM api.processes PROC,
  api.processtypes pt,
  api.jobs j,
  api.jobtypes jt,
  query.j_bl_amendrenew ar
WHERE proc.jobid           = j.jobid
AND j.jobid                = ar.jobid
AND proc.processtypeid     = pt.processtypeid
AND j.jobtypeid            = jt.jobtypeid
AND proc.datecompleted     IS NULL