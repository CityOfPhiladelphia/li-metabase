SELECT DISTINCT j.externalfilenum JobNumber,
  REPLACE(jt.description, 'Business License ', '') JobType,
  NVL(ap.licensetypesdisplayformat, ar.licensetypesdisplayformat) LicenseType,
  stat.description JobStatus,
  proc.processid ProcessID,
  pt.description ProcessType,
  Extract(MONTH FROM proc.datecompleted)
  || '/'
  ||Extract(DAY FROM proc.datecompleted)
  || '/'
  || Extract(YEAR FROM proc.datecompleted) JobAcceptedDate,
  proc.processstatus ProcessStatus,
  proc.assignedstaff AssignedStaff,
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
    WHEN jt.description LIKE 'Business License Application'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1239699&objectHandle='
      ||j.jobid
      ||'&processHandle=&paneId=1239699_151'
    WHEN jt.description LIKE 'Amendment/Renewal'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1243107&objectHandle='
      ||j.jobid
      ||'&processHandle=&paneId=1243107_175'
  END ) JobLink
FROM api.jobs j,
  api.jobtypes jt,
  api.statuses stat,
  api.processes PROC,
  api.processtypes pt,
  query.j_bl_amendrenew ar,
  query.j_bl_application ap
WHERE j.jobid          = proc.jobid
AND proc.processtypeid = pt.processtypeid
AND j.jobid            = ar.jobid (+)
AND j.jobid            = ap.jobid (+)
AND pt.processtypeid LIKE '1239327'
AND proc.datecompleted IS NOT NULL
AND j.jobtypeid         = jt.jobtypeid
AND j.statusid          = stat.statusid
AND j.completeddate    IS NULL
AND j.jobtypeid        IN ( '1240320', '1244773' )
AND j.statusid NOT     IN ( '1014809', '978845', '964970', '967394' )
ORDER BY j.externalfilenum