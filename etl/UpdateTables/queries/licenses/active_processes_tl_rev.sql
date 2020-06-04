SELECT DISTINCT j.jobnumber,
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
                        WHEN j.jobtype = 'Application'
                        THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=2854033&objectHandle='
                        || j.jobid || '&processHandle=' || proc.processid || '&paneId=2854033_116'
                        WHEN j.jobtype IN (
                            'Renewal',
                            'Amendment'
                        )
                        THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=2857688&objectHandle='
                        || j.jobid || '&processHandle=' || proc.processid || '&paneId=2857688_87'
                    END
                ) processlink
FROM g_mvw_processes proc,
     g_mvw_tl_jobs j
WHERE proc.jobid = j.jobid
      AND proc.datecompleted IS NULL
      AND proc.processtype NOT IN (
    'Pay Fees',
    'Provide More Information for Renewal',
    'Amend License'
)
-- AND jt.jobtypeid         IN ( '2853921', '2857525' ) shouldn't be necessary anymore since we're inner joining with g_mvw_tl_jobs
      AND j.jobstatus NOT IN (
    'Approved',
    'Deleted',
    'Draft',
    'Withdrawn',
    'More Information Required',
    'Denied'
)