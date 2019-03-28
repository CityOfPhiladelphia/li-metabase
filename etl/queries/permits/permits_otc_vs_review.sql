SELECT NVL(otc.PermitDescription, review.PermitDescription) PermitDescription,
  NVL(otc.issuedate, review.issuedate) IssueDate,
  NVL(otc.typeofwork, review.typeofwork) TypeOfWork,
  (
  CASE
    WHEN otc.countotcpermits IS NOT NULL
    THEN otc.countotcpermits
    ELSE 0
  END) countotcpermits,
  (
  CASE
    WHEN review.countreviewpermits IS NOT NULL
    THEN review.countreviewpermits
    ELSE 0
  END) countreviewpermits
FROM
  (SELECT PermitDescription,
    issuedate,
    TYPEOFWORK,
    COUNT(DISTINCT PermitNumber) countotcpermits
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
  ) otc
FULL OUTER JOIN
  (SELECT PermitDescription,
    issuedate,
    TypeOfWork,
    COUNT(DISTINCT PermitNumber) countreviewpermits
  FROM
    (SELECT PermitNumber,
      PermitDescription,
      TypeOfWork,
      TO_DATE(permitissueyear
      || '/'
      || permitissuemonth
      || '/'
      || '01','yyyy/mm/dd') AS issuedate
    FROM
      (SELECT trim(b.apno) PermitNumber,
        defn.APDESC PermitDescription,
        b.worktype TypeOfWork,
        EXTRACT(YEAR FROM NVL(NVL(aprec.stopdttm, aprec.startdttm), b.issdttm)) permitissueyear,
        EXTRACT(MONTH FROM NVL(NVL(aprec.stopdttm, aprec.startdttm), b.issdttm)) permitissuemonth
      FROM imsv7.apbldg b,
        imsv7.apact act,
        imsv7.aprec aprec,
        imsv7.apdefn defn
      WHERE b.apdefnkey                    = defn.apdefnkey
      AND TO_DATE(b.APDTTM, 'YYYY-MM-DD') != TO_DATE(b.ISSDTTM, 'YYYY-MM-DD')
      AND b.APKEY                          = act.APKEY (+)
      AND b.APKEY                          = aprec.APKEY (+)
      AND b.APDTTM                        >= '01-JAN-2016'
      AND b.parentkey                      = '1'
      AND aprec.logtype LIKE 'RPTPER%'
      UNION
      SELECT trim(u.apno) PermitNumber,
        defn.APDESC PermitDescription,
        u.worktype TypeOfWork,
        EXTRACT(YEAR FROM NVL(NVL(aprec.stopdttm, aprec.startdttm), u.issdttm)) permitissueyear,
        EXTRACT(MONTH FROM NVL(NVL(aprec.stopdttm, aprec.startdttm), u.issdttm)) permitissuemonth
      FROM imsv7.apuse u,
        imsv7.apact act,
        imsv7.aprec aprec,
        imsv7.apdefn defn
      WHERE u.apdefnkey                    = defn.apdefnkey
      AND TO_DATE(u.APDTTM, 'YYYY-MM-DD') != TO_DATE(u.ISSDTTM, 'YYYY-MM-DD')
      AND u.APKEY                          = act.APKEY (+)
      AND u.Apkey                          = aprec.apkey (+)
      AND u.APDTTM                        >= '01-JAN-2016'
      AND u.parentkey                      = '1'
      )
    )
  GROUP BY issuedate,
    PermitDescription,
    TypeOfWork
  ORDER BY issuedate,
    PermitDescription,
    TypeOfWork
  ) review
ON otc.PermitDescription = review.PermitDescription
AND otc.issuedate        = review.issuedate
AND otc.TypeOfWork       = review.TypeOfWork
ORDER BY issuedate,
  PermitDescription,
  TypeOfWork
