SELECT PermitDescription,
  issuedate,
  TYPEOFWORK,
  COUNT(DISTINCT PermitNumber) countpermits
FROM
  (SELECT PermitNumber,
    PermitDescription,
    TO_DATE(permitissueyear
    || '/'
    || permitissuemonth
    || '/'
    || '01','yyyy/mm/dd') AS issuedate,
    TYPEOFWORK
  FROM
    (SELECT p.PERMITNUMBER,
      p.PERMITDESCRIPTION,
      EXTRACT(YEAR FROM p.PermitIssueDate) permitissueyear,
      EXTRACT(MONTH FROM p.PermitIssueDate) permitissuemonth,
      p.TYPEOFWORK
    FROM imsv7.li_allpermits p,
      imsv7.apbldg b,
      imsv7.apuse u
    WHERE p.apkey                       = b.apkey (+)
    AND p.apkey                         = u.apkey (+)
    AND (b.parentkey                    = 1
    OR b.apkey                         IS NULL)
    AND(u.parentkey                     = 1
    OR u.apkey                         IS NULL)
    AND TO_DATE(p.APDTTM, 'YYYY-MM-DD') = TO_DATE(p.PERMITISSUEDATE, 'YYYY-MM-DD')
    AND p.APDTTM                       >= '01-JAN-2016'
    )
  )
GROUP BY issuedate, 
  PermitDescription,
  TypeOFWORK
ORDER BY issuedate,
  PermitDescription,
  TypeOFWORK