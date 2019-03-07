SELECT DISTINCT
  lt.name licensetype,
  lic.externalfilenum licensenumber,
  (
      CASE
          WHEN ar.applicationtype LIKE 'Renewal' THEN 'Renewal'
      END
  ) jobtype,
  EXTRACT(YEAR FROM ar.issuedate) jobissueyear,
  EXTRACT(MONTH FROM ar.issuedate) jobissuemonth,
  fee.paymenttotal AS amount
FROM
  query.j_bl_amendrenew ar,
  query.r_bl_amendrenew_license rla,
  query.o_bl_license lic,
  lmscorral.bl_licensetype lt,
  query.o_fn_fee fee,
  api.jobs job,
  api.jobtypes jt
WHERE
  lic.licensetypeid = lt.objectid
  AND lic.objectid = rla.licenseid
  AND rla.amendrenewid = ar.jobid
  AND ar.statusdescription LIKE 'Approved'
  AND ar.applicationtype LIKE 'Renewal'
  AND ar.issuedate > '01-JAN-16'
  AND ar.issuedate < SYSDATE
  AND fee.latestpayment >= '01-JAN-16'
  AND fee.referencedobjectid = job.jobid
  AND job.jobtypeid = jt.jobtypeid
  AND ar.jobid = job.jobid
