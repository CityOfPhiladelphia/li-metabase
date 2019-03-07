SELECT jobtype,
  licensetype,
  issuedate,
  COUNT(DISTINCT licensenumber) countjobs
FROM
  ( SELECT DISTINCT licensetype,
    licensenumber,
    jobtype,
    TO_DATE(jobissueyear
    || '/'
    || jobissuemonth
    || '/'
    || '01', 'yyyy/mm/dd') AS issuedate
  FROM
    ( SELECT DISTINCT tlic.LicenseNumber,
      tap.applicationtype JobType,
      tlic.licensetype LicenseType,
      EXTRACT(YEAR FROM tlic.initialissuedate) JOBISSUEYEAR,
      EXTRACT(MONTH FROM tlic.initialissuedate) JOBISSUEMONTH
    FROM query.o_tl_license tlic,
      query.j_tl_application tap,
      query.r_tlapplicationcal apl
    WHERE tlic.objectid        = tap.tradelicenseobjectid (+)
    AND tap.jobid              = apl.tlapplicationobjectid (+)
    AND tlic.initialissuedate >= '01-JAN-16'
    AND tlic.initialissuedate  < SYSDATE
    AND tap.statusdescription LIKE 'Approved'
    UNION
    SELECT DISTINCT tlic.licensenumber,
      tar.applicationtype JobType,
      tlic.licensetype LicenseType,
      EXTRACT(YEAR FROM tar.completeddate) jobissueyear,
      EXTRACT(MONTH FROM tar.completeddate) jobissuemonth
    FROM query.o_tl_license tlic,
      query.r_tl_amendrenew_license lra,
      query.j_tl_amendrenew tar
    WHERE tlic.objectid    = lra.licenseid (+)
    AND lra.amendrenewid   = tar.objectid (+)
    AND tar.completeddate >= '01-JAN-16'
    AND tar.completeddate  < SYSDATE
    AND tar.statusdescription LIKE 'Approved'
    AND tar.applicationtype LIKE 'Renewal'
    )
  )
GROUP BY issuedate,
  jobtype,
  licensetype
ORDER BY issuedate,
  jobtype,
  licensetype
  --runtime 86 sec
