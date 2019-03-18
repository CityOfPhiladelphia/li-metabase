SELECT DISTINCT lic.licensetype LicenseType,
  lic.LicenseNumber,
  ap.externalfilenum JobNumber,
  ap.applicationtype JobType,
  lic.LICENSEISSUEDATE JobIssueDate
FROM lmscorral.tl_tradelicenses lic,
  query.j_tl_application ap
WHERE lic.objectid    = ap.tradelicenseobjectid (+)
AND lic.LICENSEISSUEDATE >= '01-JAN-16'
AND lic.LICENSEISSUEDATE  < SYSDATE
AND ap.statusdescription LIKE 'Approved'
UNION
SELECT DISTINCT lic.licensetype LicenseType,
  lic.licensenumber,
  tar.externalfilenum JobNumber,
  tar.applicationtype JobType,
  tar.completeddate jobissuedate
FROM lmscorral.tl_tradelicenses lic,
  query.r_tl_amendrenew_license ar,
  query.j_tl_amendrenew tar
WHERE lic.objectid     = ar.licenseid (+)
AND ar.amendrenewid    = tar.objectid (+)
AND tar.completeddate >= '01-JAN-16'
AND tar.completeddate  < SYSDATE
AND tar.statusdescription LIKE 'Approved'
AND tar.applicationtype LIKE 'Renewal'