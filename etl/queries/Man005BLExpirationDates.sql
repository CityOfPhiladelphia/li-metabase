SELECT lic.licensenumber LicenseNumber,
  lt.name LicenseType,
  TO_DATE(lg.expirationdate) ExpirationDate,
  (
  CASE
    WHEN ap.createdby LIKE '%2%'
    THEN 'Online'
    WHEN ap.createdby LIKE '%3%'
    THEN 'Online'
    WHEN ap.createdby LIKE '%4%'
    THEN 'Online'
    WHEN ap.createdby LIKE '%5%'
    THEN 'Online'
    WHEN ap.createdby LIKE '%6%'
    THEN 'Online'
    WHEN ap.createdby LIKE '%7%'
    THEN 'Online'
    WHEN ap.createdby LIKE '%8%'
    THEN 'Online'
    WHEN ap.createdby LIKE '%9%'
    THEN 'Online'
    WHEN ap.createdby = 'PPG User'
    THEN 'Online'
    WHEN ap.createdby = 'POSSE system power user'
    THEN 'Revenue'
    ELSE 'Staff'
  END) CreatedByType,
  ap.externalfilenum JobNumber,
  REPLACE(jt.name, 'j_BL_', '') JobType,
  Extract(MONTH FROM ap.createddate)
  || '/'
  ||Extract(DAY FROM ap.createddate)
  || '/'
  || Extract(YEAR FROM ap.createddate) JobCreatedDate,
  Extract(MONTH FROM ap.completeddate)
  || '/'
  ||Extract(DAY FROM ap.completeddate)
  || '/'
  || Extract(YEAR FROM ap.completeddate) JobCompletedDate,
  (
  CASE
    WHEN jt.description LIKE 'Business License Application'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1239699&objectHandle='
      ||apl.applicationobjectid
      ||'&processHandle=&paneId=1239699_151'
  END ) JobLink
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
  WHERE expirationdate >= add_months(TRUNC(SYSDATE, 'MM'),-13)
  ) lg,
  query.r_bl_application_license apl,
  query.j_bl_application ap,
  query.o_jobtypes jt
WHERE lt.objectid            = lic.licensetypeobjectid (+)
AND lic.licensegroupobjectid = lg.objectid (+)
AND lic.objectid             = apl.licenseobjectid (+)
AND apl.applicationobjectid  = ap.objectid(+)
AND ap.jobtypeid             = jt.jobtypeid (+)
AND lic.mostrecentissuedate BETWEEN ( ap.completeddate - 1 ) AND ( ap.completeddate + 1 )
AND ap.statusid LIKE '1036493'
AND ap.externalfilenum LIKE 'BA%'
AND lic.licensetypeobjectid != 10571
AND lg.expirationdate IS NOT NULL
UNION
SELECT lic.licensenumber LicenseNumber,
  lt.name LicenseType,
  TO_DATE(lg.expirationdate) ExpirationDate,
  (
  CASE
    WHEN ar.createdby LIKE '%2%'
    THEN 'Online'
    WHEN ar.createdby LIKE '%3%'
    THEN 'Online'
    WHEN ar.createdby LIKE '%4%'
    THEN 'Online'
    WHEN ar.createdby LIKE '%5%'
    THEN 'Online'
    WHEN ar.createdby LIKE '%6%'
    THEN 'Online'
    WHEN ar.createdby LIKE '%7%'
    THEN 'Online'
    WHEN ar.createdby LIKE '%8%'
    THEN 'Online'
    WHEN ar.createdby LIKE '%9%'
    THEN 'Online'
    WHEN ar.createdby = 'PPG User'
    THEN 'Online'
    WHEN ar.createdby = 'POSSE system power user'
    THEN 'Revenue'
    ELSE 'Staff'
  END ) CreatedByType,
  ar.externalfilenum JobNumber,
  REPLACE(jt.name, 'j_BL_', '') JobType,
  Extract(MONTH FROM ar.createddate)
  || '/'
  ||Extract(DAY FROM ar.createddate)
  || '/'
  || Extract(YEAR FROM ar.createddate) JobCreatedDate,
  Extract(MONTH FROM ar.completeddate)
  || '/'
  ||Extract(DAY FROM ar.completeddate)
  || '/'
  || Extract(YEAR FROM ar.completeddate) JobCompletedDate,
  (
  CASE
    WHEN jt.description LIKE 'Amendment/Renewal'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1243107&objectHandle='
      ||arl.amendrenewid
      ||'&processHandle=&paneId=1243107_175'
  END ) JobLink
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
  WHERE expirationdate >= add_months(TRUNC(SYSDATE, 'MM'),-13)
  ) lg,
  query.r_bl_amendrenew_license arl,
  query.j_bl_amendrenew ar,
  query.o_jobtypes jt
WHERE lt.objectid            = lic.licensetypeobjectid (+)
AND lic.licensegroupobjectid = lg.objectid (+)
AND lic.objectid             = arl.licenseid (+)
AND arl.amendrenewid         = ar.objectid (+)
AND ar.jobtypeid             = jt.jobtypeid (+)
AND lic.mostrecentissuedate BETWEEN ( ar.completeddate - 1 ) AND ( ar.completeddate + 1 )
AND ar.statusid LIKE '1036493'
AND ar.externalfilenum LIKE 'BR%'
AND lic.licensetypeobjectid != 10571
AND lg.expirationdate IS NOT NULL