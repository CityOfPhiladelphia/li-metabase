SELECT DISTINCT j.jobnumber,
                j.jobtype,
                j.licensetype,
                j.jobstatus,
                proc.processid,
                proc.processtype,
                proc.datecompleted jobaccepteddate,
                proc.processstatus processstatus,
                proc.currentstaffassigned assignedstaff,
                (
                    CASE
                        WHEN round (sysdate - proc.scheduledstartdate) <= 1
                        THEN '0-1 Day'
                        WHEN round (sysdate - proc.scheduledstartdate) BETWEEN 2 AND 5
                        THEN '2-5 Days'
                        WHEN round (sysdate - proc.scheduledstartdate) BETWEEN 6 AND 10
                        THEN '6-10 Days'
                        WHEN round (sysdate - proc.scheduledstartdate) BETWEEN 11 AND 365
                        THEN '11 Days-1 Year'
                        ELSE 'Over 1 Year'
                    END
                ) timesincescheduledstartdate,
                (
                    CASE
                        WHEN j.jobtype LIKE 'Application'
                        THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=2854033&objectHandle='
                        || j.jobid || '&processHandle=&paneId=2854033_116'
                        WHEN j.jobtype LIKE 'Amendment'
                             OR j.jobtype LIKE 'Renewal'
                        THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=2857688&objectHandle='
                        || j.jobid || '&processHandle=&paneId=2857688_87'
                    END
                ) joblink
FROM g_mvw_tl_jobs j,
     g_mvw_processes proc
WHERE j.jobid = proc.jobid
      --AND allj.jobnumber LIKE 'T%'
      AND j.completeddate IS NULL
      AND proc.processtype IN (
    'Amend License',
    'Amendment on Renewal',
    'Completeness Check',
    'Generate License',
    'Renew License',
    'Renewal Review Application',
    'Review Application'
)
      AND proc.datecompleted IS NOT NULL
      AND j.jobstatus NOT IN (
    'More Information Required',
    'Payment Pending',
    'Application Incomplete',
    'Draft'
)