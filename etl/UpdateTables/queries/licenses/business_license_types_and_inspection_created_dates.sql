SELECT lt.name LicenseType,
  inspe.InspectionCreatedDate
FROM lmscorral.bl_licensetype lt,
  (SELECT l.licensenumber,
      l.LICENSETYPEOBJECTID
  FROM lmscorral.bl_license l,
    lmscorral.bl_joblicensexref x,
    api.processes p,
    api.processtypes pt
  WHERE l.objectid    = x.licenseobjectid
  AND x.jobid         = p.jobid
  AND p.processtypeid = pt.processtypeid
  AND pt.processtypeid LIKE '1239327'
  AND p.datecompleted IS NOT NULL
  ) cc,
  (SELECT DISTINCT insp.LicenseNumber,
    insp.createddate InspectionCreatedDate
  FROM
    (SELECT lic.ExternalFileNum LicenseNumber,
      ins.createddate
    FROM QUERY.J_BL_INSPECTION ins,
      QUERY.R_BL_LICENSEINSPECTION li,
      query.o_bl_license lic
    WHERE ins.ObjectId     = li.InspectionId
    AND li.LicenseId       = lic.ObjectId
    AND ins.CompletedDate IS NULL
    UNION
    SELECT lic.ExternalFileNum LicenseNumber,
      ins.createddate
    FROM QUERY.J_BL_INSPECTION ins,
      query.r_bl_applicationinspection api,
      query.j_bl_application ap,
      query.r_bl_application_license apl,
      query.o_bl_license lic
    WHERE ins.ObjectId      = api.InspectionId
    AND api.ApplicationId   = ap.ObjectId
    AND ap.ObjectId         = apl.ApplicationObjectId
    AND apl.LicenseObjectId = lic.ObjectId
    AND ins.CompletedDate  IS NULL
    UNION
    SELECT lic.ExternalFileNum LicenseNumber,
      ins.createddate
    FROM QUERY.J_BL_INSPECTION ins,
      query.r_bl_amendrenewinspection ari,
      query.j_bl_amendrenew ar,
      QUERY.R_BL_AMENDRENEW_LICENSE arl,
      query.o_bl_license lic
    WHERE ins.objectid     = ari.InspectionId
    AND ari.AmendRenewId   = ar.JobId
    AND ar.ObjectId        = arl.AmendRenewId
    AND arl.LicenseId      = lic.ObjectId
    AND ins.CompletedDate IS NULL
    ) insp
  ) inspe
WHERE cc.licensenumber      = inspe.LicenseNumber (+)
AND cc.licensetypeobjectid  = lt.objectid (+)
