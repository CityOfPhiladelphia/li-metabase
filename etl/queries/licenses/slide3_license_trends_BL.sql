SELECT jobtype,
  licensetype,
  issuedate,
  COUNT(DISTINCT licensenumber) countjobs,
  SUM(amount) totalamount
FROM
  (SELECT licensetype,
    licensenumber,
    jobtype,
    TO_DATE(jobissueyear
    || '/'
    || jobissuemonth
    || '/'
    || '01','yyyy/mm/dd') AS issuedate,
    amount
  FROM
    ( SELECT DISTINCT lt.name licensetype,
      lic.externalfilenum licensenumber,
      (
      CASE
        WHEN ap.applicationtype LIKE 'Application'
        THEN 'Application'
      END ) jobtype,
      EXTRACT(YEAR FROM ap.issuedate) jobissueyear,
      EXTRACT(MONTH FROM ap.issuedate) jobissuemonth,
      fee.paymenttotal AS amount
    FROM query.j_bl_application ap,
      query.r_bl_application_license rla,
      query.o_bl_license lic,
      lmscorral.bl_licensetype lt,
      query.o_fn_fee fee,
      api.jobs job,
      api.jobtypes jt
    WHERE lic.licensetypeid     = lt.objectid
    AND lic.objectid            = rla.licenseobjectid
    AND rla.applicationobjectid = ap.jobid
    AND ap.statusdescription LIKE 'Approved'
    AND ap.issuedate          >= '01-JAN-16'
    AND ap.issuedate           < SYSDATE
    AND fee.latestpayment     >= '01-JAN-16'
    AND fee.referencedobjectid = job.jobid
    AND job.jobtypeid          = jt.jobtypeid
    AND ap.jobid               = job.jobid
    UNION
    SELECT DISTINCT lt.name licensetype,
      lic.externalfilenum licensenumber,
      (
      CASE
        WHEN ar.applicationtype LIKE 'Renewal'
        THEN 'Renewal'
      END ) jobtype,
      EXTRACT(YEAR FROM ar.issuedate) jobissueyear,
      EXTRACT(MONTH FROM ar.issuedate) jobissuemonth,
      fee.paymenttotal AS amount
    FROM query.j_bl_amendrenew ar,
      query.r_bl_amendrenew_license rla,
      query.o_bl_license lic,
      lmscorral.bl_licensetype lt,
      query.o_fn_fee fee,
      api.jobs job,
      api.jobtypes jt
    WHERE lic.licensetypeid = lt.objectid
    AND lic.objectid        = rla.licenseid
    AND rla.amendrenewid    = ar.jobid
    AND ar.statusdescription LIKE 'Approved'
    AND ar.applicationtype LIKE 'Renewal'
    AND ar.issuedate          >= '01-JAN-16'
    AND ar.issuedate           < SYSDATE
    AND fee.latestpayment     >= '01-JAN-16'
    AND fee.referencedobjectid = job.jobid
    AND job.jobtypeid          = jt.jobtypeid
    AND ar.jobid               = job.jobid
    UNION
    SELECT DISTINCT lt.name licensetype,
      lic.externalfilenum licensenumber,
      (
      CASE
        WHEN ap.applicationtype LIKE 'Application'
        THEN 'Application'
      END ) jobtype,
      EXTRACT(YEAR FROM ap.issuedate) jobissueyear,
      EXTRACT(MONTH FROM ap.issuedate) jobissuemonth,
      0 AS amount
    FROM query.o_bl_license lic,
      lmscorral.bl_licensetype lt,
      query.j_bl_application ap
    WHERE lic.licensetypeid   = lt.objectid
    AND lic.InitialIssueDate >= '01-JAN-16'
    AND lic.InitialIssueDate  < SYSDATE
    AND lt.Name LIKE 'Activity'
    AND lic.ObjectId = ap.ActivityLicenseId
    AND ap.statusdescription LIKE 'Approved'
    )
  )
GROUP BY issuedate,
  jobtype,
  licensetype
ORDER BY issuedate,
  jobtype,
  licensetype