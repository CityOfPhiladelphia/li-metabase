SELECT job.externalfilenum jobnumber,
  (
  CASE
    WHEN jt.description LIKE 'Amendment/Renewal'
    THEN 'Amend/Renew'
    WHEN jt.description LIKE 'Business License Application'
    THEN 'Application'
  END ) AS jobtype,
  fee.latestpayment paymentdate,  
  fee.paymenttotal AS amount, fee.FeeType,
  COALESCE(ap.licensetypesdisplayformat, ar.licensetypesdisplayformat) LicenseType
FROM query.o_fn_fee fee,
  api.jobs job,
  api.jobtypes jt,
  query.j_bl_application ap,
  query.j_bl_amendrenew ar
WHERE jt.description        IN ('Amendment/Renewal', 'Business License Application')
AND fee.referencedobjectid = job.jobid
AND job.jobtypeid          = jt.jobtypeid
AND job.jobid            = ap.jobid (+)
AND job.jobid            = ar.jobid (+)
AND fee.latestpayment >= '01-JAN-2019' and fee.latestpayment < '20-NOV-2019'
