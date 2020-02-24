SELECT DISTINCT allj.jobnumber,
                allj.jobtype,
                allj.licensetype,
                allj.jobstatus,
                proc.processid,
                proc.objectdefdescription processtype,
                proc.datecompleted jobaccepteddate,
                proc.processstatus,
                proc.staffassigned assignedstaff,
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
                        || allj.jobid || '&processHandle=&paneId=1239699_151'
                        WHEN allj.jobtype LIKE 'Renewal'
                        THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1243107&objectHandle='
                        || allj.jobid || '&processHandle=&paneId=1243107_175'
                    END
                ) joblink
FROM (SELECT DISTINCT ap.jobid,
                      ap.externalfilenum jobnumber,
                      ap.applicationtype jobtype,
                      lt.name licensetype,
                      ap.statusdescription jobstatus
      FROM lmscorral.bl_application ap,
           lmscorral.bl_applicationlicensexref aplx,
           lmscorral.bl_license lic,
           lmscorral.bl_licensetype lt,
           lmscorral.bl_alljobs allj
      WHERE ap.jobid = aplx.applicationid
            AND aplx.licenseid           = lic.objectid
            AND lic.licensetypeobjectid  = lt.objectid
            AND ap.jobid                 = allj.jobid
            AND allj.completeddate IS NULL
            AND ap.statusdescription NOT IN (
          'More Information Required',
          'Payment Pending',
          'Application Incomplete',
          'Draft'
      )
  --AND ap.STATUSDESCRIPTION IN ('Distribute', 'In Adjudication','Submitted')
      UNION
      SELECT DISTINCT ar.jobid,
                      ar.externalfilenum jobnumber,
                      ar.applicationtype jobtype,
                      lt.name licensetype,
                      ar.statusdescription jobstatus
      FROM lmscorral.bl_amendmentrenewal ar,
           lmscorral.amendrenewlicensexref arlx,
           lmscorral.bl_license lic,
           lmscorral.bl_licensetype lt,
           lmscorral.bl_alljobs allj
      WHERE ar.jobid = arlx.amendrenewjobid
            AND arlx.licenseobjectid     = lic.objectid
            AND lic.licensetypeobjectid  = lt.objectid
            AND ar.jobid                 = allj.jobid
            AND allj.completeddate IS NULL
            AND ar.statusdescription NOT IN (
          'More Information Required',
          'Payment Pending',
          'Application Incomplete',
          'Draft'
      )
    --AND ap.STATUSDESCRIPTION IN ('Distribute', 'In Adjudication','Submitted')
) allj,
     lmscorral.processes proc
WHERE allj.jobid = proc.jobid
      AND proc.objectdefdescription = 'Completeness Check'
      AND proc.datecompleted IS NOT NULL
ORDER BY allj.jobnumber