SELECT PermitDescription,
  issuedate,
  COUNT(DISTINCT PermitNumber) countpermits,
  SUM(PaidFees) TotalFeesPaid
FROM
  (SELECT PermitNumber,
    PermitDescription,
    TO_DATE(permitissueyear
    || '/'
    || permitissuemonth
    || '/'
    || '01','yyyy/mm/dd') AS issuedate,
    PaidFees
  FROM
    (SELECT p.PermitNumber,
      p.PermitDescription,
      EXTRACT(YEAR FROM p.PermitIssueDate) permitissueyear,
      EXTRACT(MONTH FROM p.PermitIssueDate) permitissuemonth,
      fee1.amt AS PaidFees
    FROM imsv7.li_allpermits p,
      imsv7.apfee fee1
    WHERE p.apkey         = fee1.apkey (+)
    AND p.PermitIssueDate >= '01-JAN-16'
    AND fee1.paiddttm    IS NOT NULL
    )
  )
GROUP BY issuedate,
  PermitDescription
ORDER BY issuedate,
  PermitDescription