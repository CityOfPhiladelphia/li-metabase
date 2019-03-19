SELECT DISTINCT lic.licensenumber,
  ap.externalfilenum JobNumber,
  lt.licensecodedescription LicenseType,
  ap.applicationtype JobType,
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
    WHEN jt.description LIKE 'Trade License Application'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=2854033&objectHandle='
      ||ap.objectid
      ||'&processHandle='
    WHEN jt.description LIKE 'Trade License Amend/Renew'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=2857688&objectHandle='
      ||ap.objectid
      ||'&processHandle='
  END ) JobLink
FROM lmscorral.tl_tradelicensetypes lt,
  lmscorral.tl_tradelicenses lic,
  query.j_tl_application ap,
  query.o_jobtypes jt
WHERE lt.licensecode = lic.licensecode (+)
AND lic.objectid     = ap.tradelicenseobjectid (+)
AND ap.jobtypeid     = jt.jobtypeid (+)
AND ap.externalfilenum LIKE 'TL%'
AND ap.createddate >= '01-JAN-16'
AND ap.createddate  < sysdate
UNION
SELECT DISTINCT lic.licensenumber,
  ar.externalfilenum JobNumber,
  lt.licensecodedescription LicenseType,
  ar.applicationtype JobType,
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
    WHEN jt.description LIKE 'Trade License Application'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=2854033&objectHandle='
      ||ar.objectid
      ||'&processHandle='
    WHEN jt.description LIKE 'Trade License Amend/Renew'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=2857688&objectHandle='
      ||ar.objectid
      ||'&processHandle='
  END ) JobLink
FROM lmscorral.tl_tradelicensetypes lt,
  lmscorral.tl_tradelicenses lic,
  query.r_tl_amendrenew_license arl,
  query.j_tl_amendrenew ar,
  query.o_jobtypes jt
WHERE lt.licensecode = lic.licensecode (+)
AND lic.objectid     = arl.licenseid (+)
AND arl.amendrenewid = ar.objectid (+)
AND ar.jobtypeid     = jt.jobtypeid (+)
AND ar.externalfilenum LIKE 'TR%'
AND ar.createddate >= '01-JAN-16'
AND ar.createddate  < SYSDATE