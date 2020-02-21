SELECT lic.licensenumber licensenumber,
       lt.name licensetype,
       to_date (lg.expirationdate) expirationdate,
       NULL AS createdbytype,
       ap.externalfilenum jobnumber,
       ap.applicationtype jobtype,
       ap.createddate jobcreateddate,
       allj.completeddate jobcompleteddate,
       'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1244067&objectHandle=' || lic.objectid licenselink
FROM lmscorral.bl_licensetype lt,
     (SELECT licensenumber,
             licensetypeobjectid,
             licensegroupobjectid,
             objectid,
             mostrecentissuedate
      FROM lmscorral.bl_license
     ) lic,
     (SELECT expirationdate,
             objectid
      FROM lmscorral.bl_licensegroup
      WHERE expirationdate >= add_months (trunc (sysdate, 'MM'), - 13)
     ) lg,
     lmscorral.bl_applicationlicensexref aplx,
     lmscorral.bl_application ap,
     lmscorral.bl_alljobs allj
WHERE lt.objectid = lic.licensetypeobjectid (+)
      AND lic.licensegroupobjectid  = lg.objectid (+)
      AND lic.objectid              = aplx.licenseid (+)
      AND aplx.applicationid        = ap.jobid (+)
      AND ap.jobid                  = allj.jobid (+)
      AND lic.mostrecentissuedate BETWEEN (allj.completeddate - 1) AND (allj.completeddate + 1)
      AND ap.statusdescription      = 'Approved'
      AND ap.externalfilenum LIKE 'BA%'
      AND lt.name != 'Activity'
      AND lg.expirationdate IS NOT NULL
UNION
SELECT lic.licensenumber licensenumber,
       lt.name licensetype,
       to_date (lg.expirationdate) expirationdate,
       NULL AS createdbytype,
       ar.externalfilenum jobnumber,
       ar.applicationtype jobtype,
       ar.createddate jobcreateddate,
       allj.completeddate jobcompleteddate,
       'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1244067&objectHandle=' || lic.objectid licenselink
FROM lmscorral.bl_licensetype lt,
     (SELECT licensenumber,
             licensetypeobjectid,
             licensegroupobjectid,
             objectid,
             mostrecentissuedate
      FROM lmscorral.bl_license
     ) lic,
     (SELECT expirationdate,
             objectid
      FROM lmscorral.bl_licensegroup
      WHERE expirationdate >= add_months (trunc (sysdate, 'MM'), - 13)
     ) lg,
     lmscorral.amendrenewlicensexref arlx,
     lmscorral.bl_amendmentrenewal ar,
     lmscorral.bl_alljobs allj
WHERE lt.objectid = lic.licensetypeobjectid (+)
      AND lic.licensegroupobjectid  = lg.objectid (+)
      AND lic.objectid              = arlx.licenseobjectid (+)
      AND arlx.amendrenewjobid      = ar.jobid (+)
      AND ar.jobid                  = allj.jobid (+)
      AND lic.mostrecentissuedate BETWEEN (allj.completeddate - 1) AND (allj.completeddate + 1)
      AND ar.statusdescription      = 'Approved'
      AND ar.externalfilenum LIKE 'BR%'
      AND lt.name != 'Activity'
      AND lg.expirationdate IS NOT NULL