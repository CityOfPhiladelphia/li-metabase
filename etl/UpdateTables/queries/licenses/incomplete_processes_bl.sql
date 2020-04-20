SELECT DISTINCT *
FROM (SELECT proc.processid,
             proc.objectdefdescription processtype,
             allj.jobnumber,
             allj.jobtype,
             (
                 CASE
                     WHEN allj.licensetype IS NOT NULL
                     THEN allj.licensetype
                     ELSE '(none)'
                 END
             ) licensetype,
             allj.jobstatus,
             initcap (replace (TRIM (regexp_replace (proc.staffassigned, '[0-9]+', '')), '  ', ' ')) assignedstaff,
             (
                 CASE
                     WHEN regexp_count (proc.staffassigned, ',') IS NULL
                     THEN 0
                     ELSE regexp_count (proc.staffassigned, ',') + 1
                 END
             ) numassignedstaff,
             proc.createddate createddate,
             proc.scheduledstartdate scheduledstartdate,
             sysdate - proc.scheduledstartdate timesincescheduledstartdate,
             proc.processstatus processstatus,
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
      ) allj,
           lmscorral.processes proc
      WHERE allj.jobid = proc.jobid
            AND proc.datecompleted IS NULL
            AND (proc.staffassigned IS NULL
                 OR regexp_count (proc.staffassigned, ',') > 0)
      UNION
      SELECT proc.processid,
             proc.objectdefdescription processtype,
             allj.jobnumber,
             allj.jobtype,
             (
                 CASE
                     WHEN allj.licensetype IS NOT NULL
                     THEN allj.licensetype
                     ELSE '(none)'
                 END
             ) licensetype,
             allj.jobstatus,
             initcap (replace (TRIM (regexp_replace (proc.staffassigned, '[0-9]+', '')), '  ', ' ')) assignedstaff,
             1 numassignedstaff,
             proc.createddate createddate,
             proc.scheduledstartdate scheduledstartdate,
             sysdate - proc.scheduledstartdate timesincescheduledstartdate,
             proc.processstatus processstatus,
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
      ) allj,
           lmscorral.processes proc
      WHERE allj.jobid = proc.jobid
            AND proc.datecompleted IS NULL
            AND regexp_count (proc.staffassigned, ',') = 0
)