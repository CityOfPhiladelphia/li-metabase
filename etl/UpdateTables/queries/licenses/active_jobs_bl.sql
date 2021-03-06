SELECT DISTINCT j.jobnumber,
                j.jobtype,
                j.licensetype,
                j.jobstatus,
                proc.processid,
                proc.processtype,
                proc.datecompleted jobaccepteddate,
                proc.processstatus,
                proc.currentstaffassigned assignedstaff,
                proc.timesincescheduledstartdate,
                (
                    CASE
                        WHEN j.jobtype LIKE 'Application'
                        THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1239699&objectHandle='
                        || j.jobid || '&processHandle=&paneId=1239699_151'
                        WHEN j.jobtype LIKE 'Renewal'
                        THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1243107&objectHandle='
                        || j.jobid || '&processHandle=&paneId=1243107_175'
                    END
                ) joblink
FROM g_mvw_bl_jobs j,
     g_mvw_processes proc
WHERE j.jobid = proc.jobid
      AND j.jobcompleteddate IS NULL
      AND j.jobstatus NOT IN (
    'More Information Required',
    'Payment Pending',
    'Application Incomplete',
    'Draft'
)
      AND proc.processtype = 'Completeness Check'
      AND proc.datecompleted IS NOT NULL
ORDER BY j.jobnumber