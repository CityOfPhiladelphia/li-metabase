SELECT DISTINCT allj.jobnumber,
                allj.jobtype,
                allj.licensetype,
                allj.jobstatus,
                proc.processid,
                pt.description processtype,
                proc.datecompleted jobaccepteddate,
                proc.processstatus processstatus,
                proc.assignedstaff,
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
                        WHEN allj.jobtype LIKE 'Application'
                        THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=2854033&objectHandle='
                        || allj.jobid || '&processHandle=&paneId=2854033_116'
                        WHEN allj.jobtype LIKE 'Amendment'
                             OR allj.jobtype LIKE 'Renewal'
                        THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=2857688&objectHandle='
                        || allj.jobid || '&processHandle=&paneId=2857688_87'
                    END
                ) joblink
FROM (SELECT ar.objectid jobid,
             ar.externalfilenum jobnumber,
             ar.applicationtype jobtype,
             tl.licensetype,
             ar.statusdescription jobstatus,
             ar.completeddate
      FROM lmscorral.tl_tradelicenses tl,
           lmscorral.tl_amendmentrenewal ar
      WHERE ar.licenseobjectid = tl.objectid
      UNION
      SELECT ap.jobid,
             ap.externalfilenum jobnumber,
             ap.applicationtype jobtype,
             lt.licensecodedescription licensetype,
             ap.statusdescription jobstatus,
             ap.completeddate
      FROM lmscorral.tl_application ap,
           lmscorral.tl_tradelicensetypes lt
      WHERE ap.licensetypeobjectid = lt.objectid
) allj,
     api.processes proc,
     api.processtypes pt
WHERE allj.jobid = proc.jobid
      AND proc.processtypeid = pt.processtypeid
      AND allj.jobnumber LIKE 'T%'
      AND allj.completeddate IS NULL
-- Only include these process types: "Renewal Review Application", "Issue License", "Renew License", "Amend License", 
--    "Generate License", "Completeness Check", "Review Application", or "Amendment or Renewal
      AND proc.processtypeid IN (
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
-- don't have a status of "More Information Required", "Payment Pending", "Application Incomplete", or "Draft"
      AND initcap (allj.jobstatus) NOT IN (
    'More Information Required',
    'Payment Pending',
    'Application Incomplete',
    'Draft'
)
--ORDER BY allj.jobnumber