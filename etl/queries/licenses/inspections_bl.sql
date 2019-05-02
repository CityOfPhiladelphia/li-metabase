SELECT ins.objectid InspectionObjectId,
  lic.externalfilenum LicenseNumber,
  (
  CASE
    WHEN jt.name LIKE 'j_BL_Inspection'
    THEN ins.externalfilenum
  END) JobNumber,
  ins.inspectiontype,
  ins.INSPECTIONAGAINST,
  (
  CASE
    WHEN jt.name LIKE 'j_BL_Inspection'
    THEN 'License'
    WHEN jt.name LIKE 'j_BL_Application'
    THEN 'Application'
    WHEN jt.name LIKE 'j_BL_AmendRenew'
    THEN 'Renewal or Amend'
  END ) InspectionOn,
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
  ins.STATUSDESCRIPTION,
  ins.createinsddate InspectionCreatedDate,
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
  query.o_bl_business biz,
  query.o_jobtypes jt
WHERE ins.objectid       = li.inspectionid
AND ins.jobtypeid        = jt.jobtypeid
AND li.licenseid         = lic.objectid
AND lic.businessobjectid = biz.objectid
UNION
SELECT ins.objectid InspectionObjectId,
  lic.externalfilenum LicenseNumber,
  (
  CASE
    WHEN jt.name LIKE 'j_BL_Inspection'
    THEN ins.externalfilenum
  END) JobNumber,
  ins.inspectiontype,
  ins.INSPECTIONAGAINST,
  (
  CASE
    WHEN jt.name LIKE 'j_BL_Inspection'
    THEN 'License'
    WHEN jt.name LIKE 'j_BL_Application'
    THEN 'Application'
    WHEN jt.name LIKE 'j_BL_AmendRenew'
    THEN 'Renewal or Amend'
  END ) InspectionOn,
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
  ins.STATUSDESCRIPTION,
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
  query.o_jobtypes jt,
  query.r_bl_application_license apl,
  query.o_bl_license lic,
  query.o_bl_business biz
WHERE ins.objectid       = api.inspectionid
AND api.applicationid    = ap.objectid
AND ap.jobtypeid         = jt.jobtypeid
AND ap.objectid          = apl.applicationobjectid
AND apl.licenseobjectid  = lic.objectid
AND lic.businessobjectid = biz.objectid
UNION
SELECT ins.objectid InspectionObjectId,
  lic.externalfilenum LicenseNumber,
  (
  CASE
    WHEN jt.name LIKE 'j_BL_Inspection'
    THEN ins.externalfilenum
  END) JobNumber,
  ins.inspectiontype,
  ins.INSPECTIONAGAINST,
  (
  CASE
    WHEN jt.name LIKE 'j_BL_Inspection'
    THEN 'License'
    WHEN jt.name LIKE 'j_BL_Application'
    THEN 'Application'
    WHEN jt.name LIKE 'j_BL_AmendRenew'
    THEN 'Renewal or Amend'
  END ) InspectionOn,
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
  ins.STATUSDESCRIPTION,
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
  query.r_bl_amendrenewinspection ari,
  query.j_bl_amendrenew ar,
  query.o_jobtypes jt,
  query.r_bl_amendrenew_license arl,
  query.o_bl_license lic,
  query.o_bl_business biz
WHERE ins.objectid       = ari.inspectionid
AND ari.amendrenewid     = ar.jobid
AND ar.jobtypeid         = jt.jobtypeid
AND ar.objectid          = arl.amendrenewid
AND arl.licenseid        = lic.objectid
AND lic.businessobjectid = biz.objectid