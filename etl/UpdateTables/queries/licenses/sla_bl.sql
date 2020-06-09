SELECT DISTINCT j.jobnumber,
                j.jobtype,
                j.licensetype,
                j.jobcreateddate,
                j.jobstatus,
                proc.firstcompcheckcompleted,
                (
                    CASE
                        WHEN j.jobtype = 'Application'
                        THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1239699&objectHandle='
                        || j.jobid || '&processHandle='
                        WHEN j.jobtype IN (
                            'Renewal',
                            'Amendment'
                        )
                        THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1243107&objectHandle='
                        || j.jobid || '&processHandle='
                    END
                ) joblink
FROM g_mvw_bl_jobs j,
     (SELECT jobid,
             MIN (datecompleted) firstcompcheckcompleted
      FROM g_mvw_processes
      WHERE processtype = 'Completeness Check'
      GROUP BY jobid
     ) proc
WHERE j.jobid = proc.jobid
      AND j.jobcreateddate > add_months (trunc (sysdate, 'MM'), - 13)
      AND j.jobcreateddate < to_date (to_char (sysdate, 'MM/DD/YYYY'), 'MM/DD/YYYY')