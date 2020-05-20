SELECT DISTINCT lic.licensetype,
                lic.licensenumber,
                j.jobnumber,
                j.jobtype,
                lic.issuedate,
                j.jobstatus
FROM g_mvw_trade_licenses lic,
     g_mvw_tl_jobs j
WHERE lic.licensenumber = j.licensenumber (+)
      AND lic.issuedate >= '01-JAN-17'
      AND lic.issuedate < sysdate
      AND j.jobtype = 'Application'
UNION
SELECT DISTINCT lic.licensetype,
                lic.licensenumber,
                j.jobnumber,
                j.jobtype,
                j.completeddate issuedate,
                j.jobstatus
FROM g_mvw_trade_licenses lic,
     g_mvw_tl_jobs j
WHERE lic.licensenumber = j.licensenumber (+)
      AND j.completeddate >= '01-JAN-17'
      AND j.completeddate < sysdate
      AND j.jobstatus LIKE 'Approved'
      AND j.jobtype = 'Renewal'