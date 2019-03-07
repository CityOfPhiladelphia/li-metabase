--Query no. of monthly on-line, L&I Concourse, and mail transactions per license type.
--For business: April 2016- present
--runtime 562.093 seconds
SELECT DISTINCT issuedate,
  createdbytype,
  jobtype,
  licensetype,
  COUNT(DISTINCT jobnumber) jobnumbercount
FROM
  (SELECT TO_DATE(issueyear
    || '/'
    || issuemonth
    || '/'
    || '01','yyyy/mm/dd') AS issuedate,
    createdbytype,
    jobtype,
    licensetype,
    jobnumber
  FROM
    (SELECT *
    FROM (
      ( SELECT DISTINCT (
        CASE
          WHEN ap.createdby LIKE '%2%'
          THEN 'Online'
          WHEN ap.createdby LIKE '%3%'
          THEN 'Online'
          WHEN ap.createdby LIKE '%4%'
          THEN 'Online'
          WHEN ap.createdby LIKE '%5%'
          THEN 'Online'
          WHEN ap.createdby LIKE '%6%'
          THEN 'Online'
          WHEN ap.createdby LIKE '%7%'
          THEN 'Online'
          WHEN ap.createdby LIKE '%8%'
          THEN 'Online'
          WHEN ap.createdby LIKE '%9%'
          THEN 'Online'
          WHEN ap.createdby = 'PPG User'
          THEN 'Online'
          WHEN ap.createdby = 'POSSE system power user'
          THEN 'Revenue'
          ELSE 'Staff'
        END ) AS createdbytype,
        ap.applicationtype jobtype,
        lt.name licensetype,
        lic.externalfilenum licensenumber,
        ap.ExternalFileNum jobnumber,
        EXTRACT(MONTH FROM ap.issuedate) issuemonth,
        EXTRACT(YEAR FROM ap.issuedate) issueyear
      FROM query.j_bl_application ap,
        query.r_bl_application_license apl,
        query.o_bl_license lic,
        lmscorral.bl_licensetype lt
      WHERE lic.licensetypeid     = lt.objectid
      AND lic.objectid            = apl.licenseobjectid
      AND apl.applicationobjectid = ap.jobid
      AND ap.statusdescription LIKE 'Approved'
      AND ap.issuedate      >= '01-JAN-16'
      AND ap.IssueDate      < sysdate
      AND ap.applicationtype = 'Application'
      )
    UNION
      (SELECT DISTINCT (
        CASE
          WHEN ar.createdby LIKE '%2%'
          THEN 'Online'
          WHEN ar.createdby LIKE '%3%'
          THEN 'Online'
          WHEN ar.createdby LIKE '%4%'
          THEN 'Online'
          WHEN ar.createdby LIKE '%5%'
          THEN 'Online'
          WHEN ar.createdby LIKE '%6%'
          THEN 'Online'
          WHEN ar.createdby LIKE '%7%'
          THEN 'Online'
          WHEN ar.createdby LIKE '%8%'
          THEN 'Online'
          WHEN ar.createdby LIKE '%9%'
          THEN 'Online'
          WHEN ar.createdby = 'PPG User'
          THEN 'Online'
          WHEN ar.createdby = 'POSSE system power user'
          THEN 'Revenue'
          ELSE 'Staff'
        END ) AS createdbytype,
        ar.applicationtype jobtype,
        lt.name licensetype,
        lic.externalfilenum licensenumber,
        ar.ExternalFileNum jobnumber,
        EXTRACT(MONTH FROM ar.issuedate) issuemonth,
        EXTRACT(YEAR FROM ar.issuedate) issueyear
      FROM query.j_bl_amendrenew ar,
        query.r_bl_amendrenew_license arl,
        query.o_bl_license lic,
        lmscorral.bl_licensetype lt
      WHERE lic.licensetypeid = lt.objectid
      AND lic.objectid        = arl.licenseid
      AND arl.amendrenewid    = ar.jobid
      AND ar.statusdescription LIKE 'Approved'
      AND ar.issuedate >= '01-JAN-16'
      AND ar.issuedate < SYSDATE
      AND ar.applicationtype LIKE 'Renewal'
      )
    UNION
      (SELECT DISTINCT (
        CASE
          WHEN ap.createdby LIKE '%2%'
          THEN 'Online'
          WHEN ap.createdby LIKE '%3%'
          THEN 'Online'
          WHEN ap.createdby LIKE '%4%'
          THEN 'Online'
          WHEN ap.createdby LIKE '%5%'
          THEN 'Online'
          WHEN ap.createdby LIKE '%6%'
          THEN 'Online'
          WHEN ap.createdby LIKE '%7%'
          THEN 'Online'
          WHEN ap.createdby LIKE '%8%'
          THEN 'Online'
          WHEN ap.createdby LIKE '%9%'
          THEN 'Online'
          WHEN ap.createdby = 'PPG User'
          THEN 'Online'
          WHEN ap.createdby = 'POSSE system power user'
          THEN 'Revenue'
          ELSE 'Staff'
        END ) AS createdbytype,
        ap.applicationtype jobtype,
        lt.name licensetype,
        lic.externalfilenum licensenumber,
        ap.ExternalFileNum jobnumber,
        EXTRACT(MONTH FROM ap.issuedate) issuemonth,
        EXTRACT(YEAR FROM ap.issuedate) issueyear
      FROM query.o_bl_license lic,
        lmscorral.bl_licensetype lt,
        query.j_bl_application ap
      WHERE lic.licensetypeid   = lt.objectid
      AND lic.InitialIssueDate >= '01-JAN-16'
      AND lic.InitialIssueDate < sysdate
      AND lt.Name LIKE 'Activity'
      AND ap.ActivityLicenseId = lic.ObjectId
      AND ap.statusdescription LIKE 'Approved'
      ) )
    )
  )
GROUP BY issuedate,
  createdbytype,
  jobtype,
  licensetype
ORDER BY issuedate,
  createdbytype,
  jobtype,
  licensetype
