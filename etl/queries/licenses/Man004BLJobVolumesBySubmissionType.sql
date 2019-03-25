SELECT lt.name LicenseType,
  (
  CASE
    WHEN ap.createdbyusername LIKE '%2%'
    THEN 'Online'
    WHEN ap.createdbyusername LIKE '%3%'
    THEN 'Online'
    WHEN ap.createdbyusername LIKE '%4%'
    THEN 'Online'
    WHEN ap.createdbyusername LIKE '%5%'
    THEN 'Online'
    WHEN ap.createdbyusername LIKE '%6%'
    THEN 'Online'
    WHEN ap.createdbyusername LIKE '%7%'
    THEN 'Online'
    WHEN ap.createdbyusername LIKE '%8%'
    THEN 'Online'
    WHEN ap.createdbyusername LIKE '%9%'
    THEN 'Online'
    WHEN ap.createdbyusername = 'PPG User'
    THEN 'Online'
    WHEN ap.createdbyusername = 'POSSE system power user'
    THEN 'Revenue'
    ELSE 'Staff'
  END) AS CreatedByType,
  ap.createdbyusername CreatedByUserName,
  ap.objectid JobObjectID,
  ap.externalfilenum JobNumber,
  (
  CASE
    WHEN jt.name LIKE 'j_BL_Application'
    THEN 'Initial Application'
    WHEN jt.name LIKE 'j_BL_AmendRenew'
    THEN 'Renewal or Amendment'
  END ) JobType,
  Extract(MONTH FROM ap.createddate)
  || '/'
  ||Extract(DAY FROM ap.createddate)
  || '/'
  || Extract(YEAR FROM ap.createddate) JobCreatedDate,
  ap.createddate JobCreatedDateField,
  Extract(MONTH FROM ap.completeddate)
  || '/'
  ||Extract(DAY FROM ap.completeddate)
  || '/'
  || Extract(YEAR FROM ap.completeddate) JobCompletedDate,
  ap.statusdescription StatusDescription,
  (
  CASE
    WHEN jt.name LIKE 'j_BL_Application'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1239699&objectHandle='
      ||ap.objectid
      ||'&processHandle='
    WHEN jt.name LIKE 'j_BL_AmendRenew'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1243107&objectHandle='
      ||ap.objectid
      ||'&processHandle='
  END ) JobLink
FROM lmscorral.bl_licensetype lt,
  lmscorral.bl_license lic,
  query.r_bl_application_license apl,
  query.j_bl_application ap,
  query.o_jobtypes jt
WHERE lt.objectid           = lic.licensetypeobjectid (+)
AND lic.objectid            = apl.licenseobjectid (+)
AND apl.applicationobjectid = ap.objectid(+)
AND ap.jobtypeid            = jt.jobtypeid (+)
AND ap.statusid LIKE '1036493'
AND ap.externalfilenum LIKE 'BA%'
UNION
SELECT lt.name LicenseType,
  (
  CASE
    WHEN ar.createdbyusername LIKE '%2%'
    THEN 'Online'
    WHEN ar.createdbyusername LIKE '%3%'
    THEN 'Online'
    WHEN ar.createdbyusername LIKE '%4%'
    THEN 'Online'
    WHEN ar.createdbyusername LIKE '%5%'
    THEN 'Online'
    WHEN ar.createdbyusername LIKE '%6%'
    THEN 'Online'
    WHEN ar.createdbyusername LIKE '%7%'
    THEN 'Online'
    WHEN ar.createdbyusername LIKE '%8%'
    THEN 'Online'
    WHEN ar.createdbyusername LIKE '%9%'
    THEN 'Online'
    WHEN ar.createdbyusername = 'PPG User'
    THEN 'Online'
    WHEN ar.createdbyusername = 'POSSE system power user'
    THEN 'Revenue'
    ELSE 'Staff'
  END ) AS CreatedByType,
  ar.createdbyusername CreatedByUserName,
  ar.objectid JobObjectID,
  ar.externalfilenum JobNumber,
  (
  CASE
    WHEN jt.name LIKE 'j_BL_Application'
    THEN 'Initial Application'
    WHEN jt.name LIKE 'j_BL_AmendRenew'
    THEN 'Renewal or Amendment'
  END ) JobType,
  Extract(MONTH FROM ar.createddate)
  || '/'
  ||Extract(DAY FROM ar.createddate)
  || '/'
  || Extract(YEAR FROM ar.createddate) JobCreatedDate,
  ar.createddate JobCreatedDateField,
  Extract(MONTH FROM ar.completeddate)
  || '/'
  ||Extract(DAY FROM ar.completeddate)
  || '/'
  || Extract(YEAR FROM ar.completeddate) JobCompletedDate,
  ar.statusdescription StatusDescription,
  (
  CASE
    WHEN jt.name LIKE 'j_BL_Application'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1239699&objectHandle='
      ||ar.objectid
      ||'&processHandle='
    WHEN jt.name LIKE 'j_BL_AmendRenew'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1243107&objectHandle='
      ||ar.objectid
      ||'&processHandle='
  END ) JobLink
FROM lmscorral.bl_licensetype lt,
  lmscorral.bl_license lic,
  query.r_bl_amendrenew_license arl,
  query.j_bl_amendrenew ar,
  query.o_jobtypes jt
WHERE lt.objectid    = lic.licensetypeobjectid (+)
AND lic.objectid     = arl.licenseid (+)
AND arl.amendrenewid = ar.objectid (+)
AND ar.jobtypeid     = jt.jobtypeid (+)
AND ar.statusid LIKE '1036493'
AND ar.externalfilenum LIKE 'BR%'