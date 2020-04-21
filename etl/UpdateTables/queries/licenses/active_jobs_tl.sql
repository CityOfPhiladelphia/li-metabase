SELECT DISTINCT j.externalfilenum jobnumber,
                replace (jt.description, 'Trade License ', '') jobtype,
                nvl (lt.title, apl.licensetype) licensetype,
                stat.description jobstatus,
                proc.processid processid,
                pt.description processtype,
                proc.datecompleted jobaccepteddate,
                proc.processstatus processstatus,
                proc.assignedstaff assignedstaff,
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
                        WHEN jt.description LIKE 'Trade License Application'
                        THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=2854033&objectHandle='
                        || j.jobid || '&processHandle=&paneId=2854033_116'
                        WHEN jt.description LIKE 'Trade License Amend/Renew'
                        THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=2857688&objectHandle='
                        || j.jobid || '&processHandle=&paneId=2857688_87'
                    END
                ) joblink
FROM api.jobs j,
     api.jobtypes jt,
     api.statuses stat,
     api.processes proc,
     api.processtypes pt,
     query.j_tl_amendrenew ar,
     query.r_tl_amendrenew_license arl,
     query.r_tllicensetype lrl,
     query.o_tl_licensetype lt,
     query.j_tl_application apl
WHERE j.jobid = proc.jobid
      AND proc.processtypeid       = pt.processtypeid
      AND j.externalfilenum        = ar.externalfilenum (+)
      AND ar.objectid              = arl.amendrenewid (+)
      AND arl.licenseid            = lrl.licenseobjectid (+)
      AND lrl.licensetypeobjectid  = lt.objectid (+)
      AND j.jobid                  = apl.objectid (+)
      AND j.externalfilenum LIKE 'T%'
-- Only include these process types: "Renewal Review Application", "Issue License", "Renew License", "Amend License", 
--    "Generate License", "Completeness Check", "Review Application", or "Amendment or Renewal
      AND pt.processtypeid IN (
    '2851903',
    '2854108',
    '2852692',
    '2852680',
    '2854639',
    '2853029',
    '2854845',
    '2855079'
)
      AND proc.datecompleted IS NOT NULL
      AND j.jobtypeid              = jt.jobtypeid
      AND j.statusid               = stat.statusid
      AND j.completeddate IS NULL
-- "Trade License Amend/Renew" and "Trade License Application" jobs
      AND j.jobtypeid IN (
    '2853921',
    '2857525'
)
-- don't have a status of "More Information Required", "Payment Pending", "Application Incomplete", or "Draft"
      AND j.statusid NOT IN (
    '1014809',
    '978845',
    '964970',
    '967394'
)
ORDER BY j.externalfilenum

