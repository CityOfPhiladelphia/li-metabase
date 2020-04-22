SELECT j.jobnumber,
       j.jobtype,
       (
           CASE
               WHEN j.licensetype IS NOT NULL
               THEN j.licensetype
               ELSE '(none)'
           END
       ) licensetype,
       j.jobstatus,
       proc.processid,
       proc.processtype,
       proc.createddate,
       proc.scheduledstartdate,
       proc.processstatus,
       proc.timesincescheduledstartdate,
       (
           CASE
               WHEN j.jobtype LIKE 'Application'
               THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1239699&objectHandle=' || j.
               jobid || '&processHandle=' || proc.processid || '&paneId=1239699_151'
               WHEN j.jobtype LIKE 'Renewal'
               THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1243107&objectHandle=' || j.
               jobid || '&processHandle=' || proc.processid || '&paneId=1243107_175'
           END
       ) processlink
FROM g_mvw_bl_jobs j,
     g_mvw_processes proc
WHERE j.jobid = proc.jobid
      AND j.jobstatus NOT IN (
    'Approved',
    'Denied',
    'Draft',
    'Withdrawn',
    'More Information Required'
)
      AND proc.datecompleted IS NULL
      AND proc.processtype <> 'Pay Fees'