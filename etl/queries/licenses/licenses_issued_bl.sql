SELECT DISTINCT lt.name licensetype,
  lic.licensenumber,
  ap.ExternalFileNum jobnumber,
  ap.applicationtype jobtype,
  ap.issuedate issuedate
FROM lmscorral.bl_application ap,
  LMSCORRAL.BL_APPLICATIONLICENSEXREF apl,
  lmscorral.bl_license lic,
  lmscorral.bl_licensetype lt
WHERE lic.licensetypeobjectid     = lt.objectid
AND lic.objectid            = apl.licenseid
AND apl.applicationid = ap.jobid
AND ap.statusdescription LIKE 'Approved'
AND ap.issuedate      >= '01-JAN-16'
AND ap.IssueDate       < SYSDATE
AND ap.applicationtype = 'Application'
UNION
SELECT DISTINCT lt.name licensetype,
  lic.licensenumber,
  ar.ExternalFileNum jobnumber,
  ar.applicationtype jobtype,
  ar.issuedate issuedate
FROM lmscorral.bl_amendmentrenewal ar,
  LMSCORRAL.AMENDRENEWLICENSEXREF rla,
  lmscorral.bl_license lic,
  lmscorral.bl_licensetype lt
WHERE lic.licensetypeobjectid = lt.objectid
AND lic.objectid        = rla.licenseobjectid
AND rla.amendrenewjobid    = ar.jobid
AND ar.statusdescription LIKE 'Approved'
AND ar.issuedate >= '01-JAN-16'
AND ar.issuedate  < SYSDATE
AND ar.applicationtype LIKE 'Renewal'
UNION
SELECT DISTINCT lt.name licensetype,
  lic.licensenumber,
  ap.ExternalFileNum jobnumber,
  ap.applicationtype jobtype,
  ap.issuedate
FROM lmscorral.bl_application ap,
  lmscorral.bl_license lic,
  lmscorral.bl_licensetype lt
WHERE lic.licensetypeobjectid   = lt.objectid
AND ap.issuedate >= '01-JAN-16'
AND ap.issuedate  < SYSDATE
AND lt.Name LIKE 'Activity'
AND lic.ObjectId = ap.ActivityLicenseId
AND ap.statusdescription LIKE 'Approved'
AND ap.ISACTIVITYLICENSEAPP = 'Y'