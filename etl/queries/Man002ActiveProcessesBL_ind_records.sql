SELECT DISTINCT *
FROM
  (SELECT j.ExternalFileNum JobNumber,
    REPLACE(jt.Description, 'Business License ', '') JobType,
    ar.licensetypesdisplayformat LicenseType,
    stat.Description JobStatus,
    proc.ProcessId ProcessID,
    pt.Description ProcessType,
    extract(MONTH FROM proc.CreatedDate)
    || '/'
    ||extract(DAY FROM proc.CreatedDate)
    || '/'
    || extract(YEAR FROM proc.CreatedDate) CreatedDate,
    extract(MONTH FROM proc.ScheduledStartDate)
    || '/'
    || extract(DAY FROM proc.ScheduledStartDate)
    || '/'
    ||extract(YEAR FROM proc.ScheduledStartDate) ScheduledStartDate,
    proc.ProcessStatus ProcessStatus,
    (
    CASE
      WHEN ROUND(SYSDATE - proc.scheduledstartdate) <= 1
      THEN '0-1 Day'
      WHEN ROUND(SYSDATE - proc.scheduledstartdate) BETWEEN 2 AND 5
      THEN '2-5 Days'
      WHEN ROUND(SYSDATE - proc.scheduledstartdate) BETWEEN 6 AND 10
      THEN '6-10 Days'
      WHEN ROUND(SYSDATE - proc.scheduledstartdate) BETWEEN 11 AND 365
      THEN '11 Days-1 Year'
      ELSE 'Over 1 Year'
    END) TimeSinceScheduledStartDate,
    (
    CASE
      WHEN jt.Description LIKE 'Business License Application'
      THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1239699&objectHandle='
        ||j.JobId
        ||'&processHandle='
        ||proc.ProcessId
        ||'&paneId=1239699_151'
      WHEN jt.Description LIKE 'Amendment/Renewal'
      THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1243107&objectHandle='
        ||j.JobId
        ||'&processHandle='
        ||proc.ProcessId
        ||'&paneId=1243107_175'
    END) ProcessLink
  FROM api.PROCESSES PROC,
    api.jobs j,
    api.processtypes pt,
    api.jobtypes jt,
    api.statuses stat,
    query.j_bl_amendrenew ar
  WHERE proc.JobId          = j.JobId
  AND proc.ProcessTypeId    = pt.ProcessTypeId
  AND proc.DateCompleted   IS NULL
  AND j.JobTypeId           = jt.JobTypeId
  AND j.StatusId            = stat.StatusId
  AND pt.ProcessTypeId NOT IN ('984507','2852606','2853029')
  AND jt.JobTypeId          = '1240320'
  AND j.StatusId NOT       IN ('1030266','964970','1014809','1036493','1010379')
  AND j.jobid               = ar.jobid (+)
  UNION
  SELECT j.ExternalFileNum JobNumber,
    REPLACE(jt.Description, 'Business License ', '') JobType,
    ap.licensetypesdisplayformat LicenseType,
    stat.Description JobStatus,
    proc.ProcessId ProcessID,
    pt.Description ProcessType,
    extract(MONTH FROM proc.CreatedDate)
    || '/'
    ||extract(DAY FROM proc.CreatedDate)
    || '/'
    || extract(YEAR FROM proc.CreatedDate) CreatedDate,
    extract(MONTH FROM proc.ScheduledStartDate)
    || '/'
    || extract(DAY FROM proc.ScheduledStartDate)
    || '/'
    ||extract(YEAR FROM proc.ScheduledStartDate) ScheduledStartDate,
    proc.ProcessStatus ProcessStatus,
    (
    CASE
      WHEN ROUND(SYSDATE - proc.scheduledstartdate) <= 1
      THEN '0-1 Day'
      WHEN ROUND(SYSDATE - proc.scheduledstartdate) BETWEEN 2 AND 5
      THEN '2-5 Days'
      WHEN ROUND(SYSDATE - proc.scheduledstartdate) BETWEEN 6 AND 10
      THEN '6-10 Days'
      WHEN ROUND(SYSDATE - proc.scheduledstartdate) BETWEEN 11 AND 365
      THEN '11 Days-1 Year'
      ELSE 'Over 1 Year'
    END) TimeSinceScheduledStartDate,
    (
    CASE
      WHEN jt.Description LIKE 'Business License Application'
      THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1239699&objectHandle='
        ||j.JobId
        ||'&processHandle='
        ||proc.ProcessId
        ||'&paneId=1239699_151'
      WHEN jt.Description LIKE 'Amendment/Renewal'
      THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1243107&objectHandle='
        ||j.JobId
        ||'&processHandle='
        ||proc.ProcessId
        ||'&paneId=1243107_175'
    END) ProcessLink
  FROM api.PROCESSES PROC,
    api.jobs j,
    api.processtypes pt,
    api.jobtypes jt,
    api.statuses stat,
    query.j_bl_application ap
  WHERE proc.JobId          = j.JobId
  AND proc.ProcessTypeId    = pt.ProcessTypeId
  AND proc.DateCompleted   IS NULL
  AND j.JobTypeId           = jt.JobTypeId
  AND j.StatusId            = stat.StatusId
  AND pt.ProcessTypeId NOT IN ('984507','2852606','2853029')
  AND jt.JobTypeId          = '1244773'
  AND j.StatusId NOT       IN ('1030266','964970','1014809','1036493','1010379')
  AND j.jobid               = ap.jobid (+)
  )