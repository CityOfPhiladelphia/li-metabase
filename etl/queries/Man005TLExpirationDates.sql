SELECT lic.licensenumber LicenseNumber,
  lic.licensetype LicenseType,
  TO_DATE(lic.licenseexpirydate) ExpirationDate,
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
  REPLACE(jt.name, 'j_TL_', '') JobType,
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
  NULL LicenseRenewedOnDate,
  (
  CASE
    WHEN jt.description LIKE 'Trade License Application'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=2855291&objectHandle='
      ||lic.objectid
      ||'&processHandle='
  END ) JobLink
FROM
  (SELECT licensenumber,
    licensetype,
    licensecode,
    licenseexpirydate,
    objectid,
    licenseissuedate
  FROM lmscorral.tl_tradelicenses
  WHERE licenseexpirydate >= add_months(TRUNC(SYSDATE, 'MM'),-13)
  ) lic,
  query.j_tl_application ap,
  query.o_jobtypes jt
WHERE lic.objectid = ap.tradelicenseobjectid (+)
AND ap.jobtypeid   = jt.jobtypeid (+)
AND lic.licenseissuedate BETWEEN ( ap.completeddate - 1 ) AND ( ap.completeddate + 1 )
AND ap.statusid LIKE '1036493'
AND ap.externalfilenum LIKE 'TL%'
AND lic.licenseexpirydate IS NOT NULL
UNION
SELECT lic.licensenumber LicenseNumber,
  lic.licensetype LicenseType,
  TO_DATE(lic.licenseexpirydate) ExpirationDate,
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
  REPLACE(jt.name, 'j_TL_', '') JobType,
  Extract(MONTH FROM ar.createddate)
  || '/'
  ||Extract(DAY FROM ar.createddate)
  || '/'
  || Extract(YEAR FROM ar.createddate) JobCreatedDate,
  NULL JobCompletedDate,
  Extract(MONTH FROM ar.licenserenewedondate)
  || '/'
  ||Extract(DAY FROM ar.licenserenewedondate)
  || '/'
  || Extract(YEAR FROM ar.licenserenewedondate) LicenseRenewedOnDate,
  (
  CASE
    WHEN jt.description LIKE 'Trade License Amend/Renew'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=2855291&objectHandle='
      ||arl.amendrenewid
      ||'&processHandle=&paneId=1243107_175'
  END ) JobLink
FROM
  (SELECT licensenumber,
    licensetype,
    licensecode,
    licenseexpirydate,
    objectid,
    licenseissuedate
  FROM lmscorral.tl_tradelicenses
  WHERE licenseexpirydate >= add_months(TRUNC(SYSDATE, 'MM'),-13)
  ) lic,
  query.r_tl_amendrenew_license arl,
  query.j_tl_amendrenew ar,
  query.o_jobtypes jt
WHERE lic.objectid   = arl.licenseid (+)
AND arl.amendrenewid = ar.objectid (+)
AND ar.jobtypeid     = jt.jobtypeid (+)
AND ar.licenserenewedondate BETWEEN ( ar.completeddate - 1 ) AND ( ar.completeddate + 1 )
AND ar.statusid LIKE '1036493'
AND ar.externalfilenum LIKE 'TR%'
AND lic.licenseexpirydate IS NOT NULL