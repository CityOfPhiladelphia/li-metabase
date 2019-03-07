SELECT proc.processid,
  pt.description ProcessType,
  j.ExternalFileNum JobNumber,  
  REPLACE(jt.description, 'Trade License ', '') JobType,
  lt.title LicenseType,
  (CASE
    WHEN proc.ASSIGNEDSTAFF IS NULL
    THEN NULL
    WHEN regexp_count(ASSIGNEDSTAFF, ',') = 0
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
    WHEN jt.description LIKE 'Trade License Application'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=2854033&objectHandle='
      ||j.jobid
      ||'&processHandle='
      ||proc.processid
      ||'&paneId=2854033_116'
  END ) JobLink
FROM api.processes PROC,
  api.processtypes pt,
  api.jobs j,
  api.jobtypes jt,
  query.j_tl_application ap,
  query.r_tllicensetype lrl,
  query.o_tl_licensetype lt
WHERE proc.jobid            = j.jobid
AND j.jobid                 = ap.objectid
AND ap.tradelicenseobjectid = lrl.licenseobjectid (+)
AND lrl.licensetypeobjectid = lt.objectid (+)
AND proc.processtypeid      = pt.processtypeid
AND j.jobtypeid             = jt.jobtypeid
AND proc.datecompleted      IS NULL
UNION
SELECT proc.processid,
  pt.description ProcessType,
  j.ExternalFileNum JobNumber,  
  REPLACE(jt.description, 'Trade License ', '') JobType,
  lt.title LicenseType,
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
    WHEN jt.description LIKE 'Trade License Amend/Renew'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=2857688&objectHandle='
      ||j.jobid      
      ||'&processHandle='
      ||proc.processid
      ||'&paneId=2857688_87'
  END ) JobLink
FROM api.processes PROC,
  api.processtypes pt,
  api.jobs j,
  api.jobtypes jt,
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
AND proc.datecompleted      IS NULL