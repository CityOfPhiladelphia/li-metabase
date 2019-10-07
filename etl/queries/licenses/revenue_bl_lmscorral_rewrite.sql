SELECT job.externalfilenum jobnumber,
  (
  CASE
    WHEN job.OBJECTDEFDESCRIPTION LIKE 'Amendment/Renewal'
    THEN 'Amend/Renew'
    WHEN job.OBJECTDEFDESCRIPTION LIKE 'Business License Application'
    THEN 'Application'
  END ) AS jobtype,
  fee.latestpayment paymentdate,
  fee.paymenttotal AS amount,
  fee.FeeType,
  lt.name LicenseType
FROM lmscorral.fee fee,
  lmscorral.bl_alljobs job,
  LMSCORRAL.BL_JOBLICENSEXREF jl,
  lmscorral.bl_license lic,
  lmscorral.bl_licensetype lt
WHERE fee.latestpayment      >= '01-JAN-16'
AND fee.latestpayment         < '20-SEP-19'
AND job.OBJECTDEFDESCRIPTION IN ('Amendment/Renewal', 'Business License Application')
AND fee.referencedobjectid    = job.jobid
AND job.jobid                 = jl.jobid
AND jl.LICENSEOBJECTID        = lic.objectid
AND lic.LICENSETYPEOBJECTID   = lt.objectid