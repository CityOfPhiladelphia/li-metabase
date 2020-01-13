SELECT DISTINCT cc.licensenumber,
  lt.name LicenseType,
  cc.mostrecentissuedate,
  cc.MostRecentCompletenessCheck,
  lg.expirationdate,
  inspe.InspectionCreatedDate,
  inspe.ScheduledInspectionDate,
  inspe.InspectionCompletedDate,
  (
  CASE
    WHEN jt.description LIKE 'Business License Application'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1239699&objectHandle='
      ||cc.jobid
      ||'&processHandle=&paneId=1239699_151'
    WHEN jt.description LIKE 'Amendment/Renewal'
    THEN 'https://eclipseprod.phila.gov/phillylmsprod/int/lms/Default.aspx#presentationId=1243107&objectHandle='
      ||cc.jobid
      ||'&processHandle=&paneId=1243107_175'
  END ) JobLink
FROM lmscorral.bl_licensetype lt,
  lmscorral.bl_licensegroup lg,
  api.jobs j,
  api.jobtypes jt,
  (SELECT l.licensenumber,
    l.LICENSETYPEOBJECTID,
    l.LICENSEGROUPOBJECTID,
    l.MOSTRECENTISSUEDATE,
    x.jobid,
    MAX(p.datecompleted) MostRecentCompletenessCheck
  FROM lmscorral.bl_license l,
    lmscorral.bl_joblicensexref x,
    api.processes p,
    api.processtypes pt
  WHERE l.objectid    = x.licenseobjectid
  AND x.jobid         = p.jobid
  AND p.processtypeid = pt.processtypeid
  AND pt.processtypeid LIKE '1239327'
  AND p.datecompleted IS NOT NULL
  GROUP BY l.licensenumber,
    l.LICENSETYPEOBJECTID,
    l.LICENSEGROUPOBJECTID,
    l.MOSTRECENTISSUEDATE,
    x.jobid
  ) cc,
  (SELECT DISTINCT insp.LicenseNumber,
    insp.createddate InspectionCreatedDate,
    insp.scheduledInspectiondate ScheduledInspectionDate,
    insp.completeddate InspectionCompletedDate
  FROM
    (SELECT lic.ExternalFileNum LicenseNumber,
      ins.createddate,
      ins.scheduledInspectiondate,
      ins.completeddate
    FROM QUERY.J_BL_INSPECTION ins,
      QUERY.R_BL_LICENSEINSPECTION li,
      query.o_bl_license lic
    WHERE ins.ObjectId     = li.InspectionId
    AND li.LicenseId       = lic.ObjectId
    AND ins.CompletedDate IS NULL
    UNION
    SELECT lic.ExternalFileNum LicenseNumber,
      ins.createddate,
      ins.scheduledInspectiondate,
      ins.completeddate
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
      ins.createddate,
      ins.scheduledInspectiondate,
      ins.completeddate
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
AND cc.licensegroupobjectid = lg.objectid (+)
AND cc.jobid                = j.jobid (+)
AND j.jobtypeid             = jt.jobtypeid (+)
AND lt.name NOT            IN ('Activity', 'Amusement', 'Annual Pole', 'Bingo', 'Carnival', 'Dumpster License - Construction', 'Food Caterer', 'Food Estab, Retail Non-Permanent Location (Event)', 'Food Establishment, Outdoor', 'Food Establishment, Retail Perm Location (Large)', 'Food Manufacturer / Wholesaler', 'Food Preparing and Serving', 'Handbill Distribution', 'Honor Box', 'Limited Occasion', 'Outdoor Advertising Sign', 'Overhead Wire', 'Pawn Shop', 'Precious Metal Dealer', 'Promoter Registration', 'Public Garage / Parking Lot', 'Rental', 'Scales and Scanners', 'Sidewalk Cafe', 'Small Games Of Chance', 'Special Permit', 'Tow Company', 'Vacant Commercial Property', 'Vacant Residential Property / Lot', 'Vendor - Center City Vendor', 'Vendor - Motor Vehicle Sales', 'Vendor - Neighborhood Vending District', 'Vendor - On Foot', 'Vendor - Pushcart', 'Vendor - Sidewalk Sales', 'Vendor - Special Vending', 'Dumpster License - Private Property', 'Food Estab, Retail Non-Permanent Location (Annual)', 'Food Establishment, Retail Permanent Location', 'Food Preparing and Serving (30+ SEATS)', 'Dumpster License - Public ROW')
AND cc.MostRecentCompletenessCheck < TO_DATE(TO_CHAR(sysdate, 'MM/DD/YYYY'), 'MM/DD/YYYY')