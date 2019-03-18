SELECT DISTINCT lic.licensenumber,
  ap.externalfilenum JobNumber,
  lt.name LicenseType,
  ap.applicationtype jobtype,
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
  END) AS SubmissionMode,
  ap.createdbyusername CreatedByUserName,
  ap.createddate JobCreatedDate,
  ap.completeddate JobCompletedDate,
  ap.statusdescription Status,
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
AND ap.createddate         >= '01-JAN-16'
AND ap.createddate          < sysdate
AND ap.externalfilenum LIKE 'BA%'
UNION
SELECT DISTINCT lic.licensenumber,
  ar.externalfilenum JobNumber,
  lt.name LicenseType,
  ar.applicationtype jobtype,
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
  END ) AS SubmissionMode,
  ar.createdbyusername CreatedByUserName,
  ar.createddate JobCreatedDate,
  ar.completeddate JobCompletedDate,
  ar.statusdescription Status,
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
AND ar.createddate  >= '01-JAN-16'
AND ar.createddate   < SYSDATE
AND ar.externalfilenum LIKE 'BR%'