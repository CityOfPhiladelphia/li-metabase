SELECT DISTINCT
  lt.name licensetype,
  lic.externalfilenum licensenumber,
  (
      CASE
          WHEN ap.applicationtype LIKE 'Application' THEN 'Application'
      END
  ) jobtype,
  EXTRACT(YEAR FROM ap.issuedate) jobissueyear,
  EXTRACT(MONTH FROM ap.issuedate) jobissuemonth,
  fee.paymenttotal AS amount
FROM
  query.j_bl_application ap,
  query.r_bl_application_license apl,
  query.o_bl_license lic,
  lmscorral.bl_licensetype lt,
  query.o_fn_fee fee,
  api.jobs job,
  api.jobtypes jt
WHERE
  lic.licensetypeid = lt.objectid
  AND lic.objectid = apl.licenseobjectid
  AND apl.applicationobjectid = ap.jobid
  AND ap.statusdescription LIKE 'Approved'
  AND ap.issuedate > '01-JAN-16'
  AND ap.issuedate < SYSDATE
  AND ap.issuedate > '01-OCT-18'
  AND fee.referencedobjectid = job.jobid
  AND job.jobtypeid = jt.jobtypeid
  AND ap.jobid = job.jobid
