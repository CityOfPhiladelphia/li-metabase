SELECT DISTINCT lic.licensenumber,
                lic.licensetype,
                lic.issuedate,
                lic.expirationdate,
                j.jobnumber,
                j.jobtype,
                j.createddate jobcreateddate,
                j.completeddate jobcompleteddate,
                (
                    CASE
                        WHEN j.createdby LIKE '%2%'
                        THEN 'Online'
                        WHEN j.createdby LIKE '%3%'
                        THEN 'Online'
                        WHEN j.createdby LIKE '%4%'
                        THEN 'Online'
                        WHEN j.createdby LIKE '%5%'
                        THEN 'Online'
                        WHEN j.createdby LIKE '%6%'
                        THEN 'Online'
                        WHEN j.createdby LIKE '%7%'
                        THEN 'Online'
                        WHEN j.createdby LIKE '%8%'
                        THEN 'Online'
                        WHEN j.createdby LIKE '%9%'
                        THEN 'Online'
                        WHEN j.createdby = 'PPG User'
                        THEN 'Online'
                        WHEN j.createdby = 'POSSE system power user'
                        THEN 'Revenue'
                        ELSE 'Staff'
                    END
                ) submissionmode,
                j.createdby createdbyusername,
                j.jobstatus,
                'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=2855291&objectHandle=' || lic.objectid
                AS licenselink
FROM g_mvw_trade_licenses lic,
     g_mvw_tl_jobs j
WHERE lic.licensenumber = j.licensenumber (+)
      AND j.createddate >= '01-JAN-17'
      AND j.createddate < sysdate
      AND (j.jobnumber LIKE 'TL%'
           OR j.jobnumber LIKE 'TR%')