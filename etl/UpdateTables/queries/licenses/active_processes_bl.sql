SELECT DISTINCT *
FROM (SELECT allj.jobnumber,
             allj.jobtype,
             (
                 CASE
                     WHEN allj.licensetype IS NOT NULL
                     THEN allj.licensetype
                     ELSE '(none)'
                 END
             ) licensetype,
             allj.jobstatus,
             proc.processid processid,
             proc.objectdefdescription processtype,
             proc.createddate createddate,
             proc.scheduledstartdate scheduledstartdate,
             proc.processstatus processstatus,
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
                     THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1239699&objectHandle='
                     || allj.jobid || '&processHandle=' || proc.processid || '&paneId=1239699_151'
                     WHEN allj.jobtype LIKE 'Renewal'
                     THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1243107&objectHandle='
                     || allj.jobid || '&processHandle=' || proc.processid || '&paneId=1243107_175'
                 END
             ) processlink
      FROM (SELECT DISTINCT ap.jobid,
                            ap.externalfilenum jobnumber,
                            ap.applicationtype jobtype,
                            lt.name licensetype,
                            ap.statusdescription jobstatus
            FROM lmscorral.bl_application ap,
                 lmscorral.bl_joblicensetypexref jltx,
                 lmscorral.bl_licensetype lt,
                 lmscorral.bl_alljobs allj
            WHERE ap.jobid = jltx.jobid (+)
                  AND jltx.licenseobjectid  = lt.objectid (+)
                  AND ap.jobid              = allj.jobid
                  AND ap.statusdescription NOT IN (
                'Approved',
                'Denied',
                'Draft',
                'Withdrawn',
                'More Information Required'
            )
            UNION
            SELECT DISTINCT ar.jobid,
                            ar.externalfilenum jobnumber,
                            ar.applicationtype jobtype,
                            lt.name licensetype,
                            ar.statusdescription jobstatus
            FROM lmscorral.bl_amendmentrenewal ar,
                 lmscorral.bl_joblicensetypexref jltx,
                 lmscorral.bl_licensetype lt,
                 lmscorral.bl_alljobs allj
            WHERE ar.jobid = jltx.jobid (+)
                  AND jltx.licenseobjectid  = lt.objectid (+)
                  AND ar.jobid              = allj.jobid
                  AND ar.statusdescription NOT IN (
                'Approved',
                'Denied',
                'Draft',
                'Withdrawn',
                'More Information Required'
            )
      ) allj,
           lmscorral.processes proc
      WHERE allj.jobid = proc.jobid
            AND proc.datecompleted IS NULL
            AND proc.objectdefdescription <> 'Pay Fees'
     )