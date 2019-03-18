SELECT DISTINCT lt.name licensetype,
  lic.externalfilenum licensenumber,
  ap.ExternalFileNum jobnumber,
  ap.applicationtype jobtype,
  ap.issuedate jobissuedate
FROM query.j_bl_application ap,
  query.r_bl_application_license apl,
  query.o_bl_license lic,
  lmscorral.bl_licensetype lt
WHERE lic.licensetypeid     = lt.objectid
AND lic.objectid            = apl.licenseobjectid
AND apl.applicationobjectid = ap.jobid
AND ap.statusdescription LIKE 'Approved'
AND ap.issuedate      >= '01-JAN-16'
AND ap.IssueDate       < SYSDATE
AND ap.applicationtype = 'Application'
UNION
SELECT DISTINCT lt.name licensetype,
  lic.externalfilenum licensenumber,
  ar.ExternalFileNum jobnumber,
  ar.applicationtype jobtype,
  ar.issuedate jobissuedate
FROM query.j_bl_amendrenew ar,
  query.r_bl_amendrenew_license rla,
  query.o_bl_license lic,
  lmscorral.bl_licensetype lt
WHERE lic.licensetypeid = lt.objectid
AND lic.objectid        = rla.licenseid
AND rla.amendrenewid    = ar.jobid
AND ar.statusdescription LIKE 'Approved'
AND ar.issuedate >= '01-JAN-16'
AND ar.issuedate  < SYSDATE
AND ar.applicationtype LIKE 'Renewal'
UNION
SELECT DISTINCT lt.name licensetype,
  lic.externalfilenum licensenumber,
  ap.ExternalFileNum jobnumber,
  ap.applicationtype jobtype,
  ap.IssueDate jobissuedate
FROM query.o_bl_license lic,
  lmscorral.bl_licensetype lt,
  query.j_bl_application ap
WHERE lic.licensetypeid   = lt.objectid
AND lic.InitialIssueDate >= '01-JAN-16'
AND lic.InitialIssueDate  < SYSDATE
AND lt.Name LIKE 'Activity'
AND lic.ObjectId = ap.ActivityLicenseId
AND ap.statusdescription LIKE 'Approved'
