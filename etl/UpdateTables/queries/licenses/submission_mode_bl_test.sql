SELECT DISTINCT j.licensenumber,
                j.jobnumber,
                j.licensetype,
                j.jobtype,
                (
                    CASE
                        WHEN j.createdbyusername LIKE '%2%'
                        THEN 'Online'
                        WHEN j.createdbyusername LIKE '%3%'
                        THEN 'Online'
                        WHEN j.createdbyusername LIKE '%4%'
                        THEN 'Online'
                        WHEN j.createdbyusername LIKE '%5%'
                        THEN 'Online'
                        WHEN j.createdbyusername LIKE '%6%'
                        THEN 'Online'
                        WHEN j.createdbyusername LIKE '%7%'
                        THEN 'Online'
                        WHEN j.createdbyusername LIKE '%8%'
                        THEN 'Online'
                        WHEN j.createdbyusername LIKE '%9%'
                        THEN 'Online'
                        WHEN j.createdbyusername = 'PPG User'
                        THEN 'Online'
                        WHEN j.createdbyusername = 'POSSE system power user'
                        THEN 'Revenue'
                        ELSE 'Staff'
                    END
                ) AS submissionmode,
                j.createdbyusername,
                j.jobcreateddate,
                j.jobcompleteddate,
                j.jobstatus status,
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
FROM g_mvw_bl_jobs j
WHERE j.licensenumber IS NOT NULL
      AND j.jobcreateddate >= '01-JAN-17'
      AND j.jobcreateddate < sysdate
      AND (j.jobnumber LIKE 'BA%'
           OR j.jobnumber LIKE 'BR%')