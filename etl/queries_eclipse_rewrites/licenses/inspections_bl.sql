SELECT ins.objectid InspectionObjectId,
  lic.externalfilenum LicenseNumber,
  ins.externalfilenum JobNumber,
  ins.inspectiontype,
  (
  CASE
    WHEN ins.INSPECTIONAGAINST LIKE 'Business License'
    THEN 'License'
    WHEN ins.INSPECTIONAGAINST LIKE 'Business License Application'
    THEN 'Application'
    WHEN ins.INSPECTIONAGAINST LIKE 'Amendment/Renewal'
    THEN 'Amendment/Renewal'
  END ) InspectionAgainst,
  (
  CASE
    WHEN lic.licensetype IS NOT NULL
    THEN lic.licensetype
    ELSE '(none)'
  END ) LicenseType,
  (
  CASE
    WHEN ins.inspectorname IS NOT NULL
    THEN ins.inspectorname
    ELSE '(none)'
  END ) Inspector,
  ins.STATUSDESCRIPTION Status,
  ins.createddate InspectionCreatedDate,
  ins.scheduledinspectiondate ScheduledInspectionDate,
  (
  CASE
    WHEN ins.scheduledinspectiondate IS NOT NULL
    THEN 'Scheduled'
    WHEN ins.scheduledinspectiondate IS NULL
    THEN 'Unscheduled'
  END) ScheduledStatus,
  ins.COMPLETEDDATE,
  (
  CASE
    WHEN ins.completeddate IS NOT NULL
    THEN 'Completed'
    WHEN ins.completeddate IS NULL
    THEN 'Incomplete'
  END) CompletedStatus,
  biz.address BusinessAddress,
  'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1244842&objectHandle='
  || ins.objectid
  || '&processHandle=' LINK
FROM query.j_bl_inspection ins,
  query.r_bl_licenseinspection li,
  query.o_bl_license lic,
  query.o_bl_business biz
WHERE ins.objectid       = li.inspectionid
AND li.licenseid         = lic.objectid
AND lic.businessobjectid = biz.objectid
AND ins.createddate >= '01-JAN-2016'
UNION
SELECT ins.objectid InspectionObjectId,
  lic.externalfilenum LicenseNumber,
  ins.externalfilenum JobNumber,
  ins.inspectiontype,
  (
  CASE
    WHEN ins.INSPECTIONAGAINST LIKE 'Business License'
    THEN 'License'
    WHEN ins.INSPECTIONAGAINST LIKE 'Business License Application'
    THEN 'Application'
    WHEN ins.INSPECTIONAGAINST LIKE 'Amendment/Renewal'
    THEN 'Amendment/Renewal'
  END ) InspectionAgainst,
  (
  CASE
    WHEN lic.licensetype IS NOT NULL
    THEN lic.licensetype
    ELSE '(none)'
  END ) LicenseType,
  (
  CASE
    WHEN ins.inspectorname IS NOT NULL
    THEN ins.inspectorname
    ELSE '(none)'
  END ) Inspector,
  ins.STATUSDESCRIPTION Status,
  ins.createddate InspectionCreatedDate,
  ins.scheduledinspectiondate ScheduledInspectionDate,
  (
  CASE
    WHEN ins.scheduledinspectiondate IS NOT NULL
    THEN 'Scheduled'
    WHEN ins.scheduledinspectiondate IS NULL
    THEN 'Unscheduled'
  END) ScheduledStatus,
  ins.COMPLETEDDATE,
  (
  CASE
    WHEN ins.completeddate IS NOT NULL
    THEN 'Completed'
    WHEN ins.completeddate IS NULL
    THEN 'Incomplete'
  END) CompletedStatus,
  biz.address BusinessAddress,
  'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1244842&objectHandle='
  || ins.objectid
  || '&processHandle=' LINK
FROM query.j_bl_inspection ins,
  query.r_bl_applicationinspection api,
  query.j_bl_application ap,
  query.r_bl_application_license apl,
  query.o_bl_license lic,
  query.o_bl_business biz
WHERE ins.objectid       = api.inspectionid
AND api.applicationid    = ap.objectid
AND ap.objectid          = apl.applicationobjectid
AND apl.licenseobjectid  = lic.objectid
AND lic.businessobjectid = biz.objectid
AND ins.createddate >= '01-JAN-2016'
UNION
SELECT ins.objectid InspectionObjectId,
  lic.externalfilenum LicenseNumber,
  ins.externalfilenum JobNumber,
  ins.inspectiontype,
  (
  CASE
    WHEN ins.INSPECTIONAGAINST LIKE 'Business License'
    THEN 'License'
    WHEN ins.INSPECTIONAGAINST LIKE 'Business License Application'
    THEN 'Application'
    WHEN ins.INSPECTIONAGAINST LIKE 'Amendment/Renewal'
    THEN 'Amendment/Renewal'
  END ) InspectionAgainst,
  (
  CASE
    WHEN lic.licensetype IS NOT NULL
    THEN lic.licensetype
    ELSE '(none)'
  END ) LicenseType,
  (
  CASE
    WHEN ins.inspectorname IS NOT NULL
    THEN ins.inspectorname
    ELSE '(none)'
  END ) Inspector,
  ins.STATUSDESCRIPTION Status,
  ins.createddate InspectionCreatedDate,
  ins.scheduledinspectiondate ScheduledInspectionDate,
  (
  CASE
    WHEN ins.scheduledinspectiondate IS NOT NULL
    THEN 'Scheduled'
    WHEN ins.scheduledinspectiondate IS NULL
    THEN 'Unscheduled'
  END) ScheduledStatus,
  ins.COMPLETEDDATE,
  (
  CASE
    WHEN ins.completeddate IS NOT NULL
    THEN 'Completed'
    WHEN ins.completeddate IS NULL
    THEN 'Incomplete'
  END) CompletedStatus,
  (
  CASE
    WHEN biz.address IS NOT NULL
    THEN biz.address
    ELSE '(none)'
  END ) BusinessAddress,
  'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1244842&objectHandle='
  || ins.objectid
  || '&processHandle=' LINK
FROM query.j_bl_inspection ins,
  query.r_bl_amendrenewinspection ari,
  query.j_bl_amendrenew ar,
  query.r_bl_amendrenew_license arl,
  query.o_bl_license lic,
  query.o_bl_business biz
WHERE ins.objectid       = ari.inspectionid
AND ari.amendrenewid     = ar.jobid
AND ar.objectid          = arl.amendrenewid
AND arl.licenseid        = lic.objectid
AND lic.businessobjectid = biz.objectid
AND ins.createddate >= '01-JAN-2016'