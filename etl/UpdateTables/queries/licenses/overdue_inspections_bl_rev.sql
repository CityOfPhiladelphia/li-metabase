SELECT coalesce (a.base_address, j1.base_address, j2.base_address) businessaddress,
       coalesce (ins.licensenumber, j1.licensenumber, j2.licensenumber) licensenumber,
       (
           CASE
               WHEN lic.licensetype IS NOT NULL
               THEN lic.licensetype
               WHEN j1.licensetype IS NOT NULL
               THEN j1.licensetype
               WHEN j2.licensetype IS NOT NULL
               THEN j2.licensetype
               ELSE '(none)'
           END
       ) licensetype,
       coalesce (ins.amendrenewjobnumber, ins.applicationjobnumber) jobnumber,
       ins.inspectionnumber,
       ins.inspectionagainst,
       ins.inspectiontype,
       ins.inspectionobjectid,
       ins.createddate inspectioncreateddate,
       ins.scheduledinspectiondate,
       round (sysdate - ins.scheduledinspectiondate) daysoverdue,
       (
           CASE
               WHEN round (sysdate - ins.scheduledinspectiondate) < 7
               THEN 'Less than a week'
               WHEN round (sysdate - ins.scheduledinspectiondate) BETWEEN 7 AND 30
               THEN '7-30 days'
               WHEN round (sysdate - ins.scheduledinspectiondate) BETWEEN 31 AND 365
               THEN '31 - 365 days'
               ELSE 'More than a year'
           END
       ) timeoverdue,
       (
           CASE
               WHEN ins.inspectorname IS NOT NULL
               THEN ins.inspectorname
               ELSE '(none)'
           END
       ) inspector,
       'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1244842&objectHandle=' || ins.inspectionobjectid
       || '&processHandle=' link
FROM g_mvw_bl_inspections ins,
     (SELECT j.jobid,
             j.licensenumber,
             j.licensetype,
             a.base_address
      FROM g_mvw_bl_jobs j,
           g_mvw_business_licenses lic,
           eclipse_lni_addr a
      WHERE j.licensenumber = lic.licensenumber
            AND lic.addressobjectid = a.addressobjectid (+)
     ) j1,
     (SELECT j.jobid,
             j.licensenumber,
             j.licensetype,
             a.base_address
      FROM g_mvw_bl_jobs j,
           g_mvw_business_licenses lic,
           eclipse_lni_addr a
      WHERE j.licensenumber = lic.licensenumber
            AND lic.addressobjectid = a.addressobjectid (+)
     ) j2,    
     g_mvw_business_licenses lic,
     eclipse_lni_addr a
WHERE ins.amendrenewobjectid = j1.jobid (+)
      AND ins.applicationobjectid  = j2.jobid (+)
      AND ins.licenseobjectid      = lic.licenseobjectid (+)
      AND lic.addressobjectid      = a.addressobjectid (+)
      AND ins.scheduledinspectiondate < sysdate
      AND ins.completeddate IS NULL