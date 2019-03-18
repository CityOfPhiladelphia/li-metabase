SELECT job.externalfilenum jobnumber,
 (
  CASE
    WHEN jt.description LIKE 'Trade License Amend/Renew'
    THEN 'Amend/Renew'
    WHEN jt.description LIKE 'Trade License Application'
    THEN 'Application'
  END ) AS jobtype,
  fee.latestpayment paymentdate,
  fee.paymenttotal amount
FROM query.o_fn_fee fee,
  api.jobs job,
  api.jobtypes jt
WHERE fee.latestpayment   >= '01-JAN-16'
AND jt.description        IN ('Trade License Amend/Renew', 'Trade License Application')
AND fee.referencedobjectid = job.jobid
AND job.jobtypeid          = jt.jobtypeid 