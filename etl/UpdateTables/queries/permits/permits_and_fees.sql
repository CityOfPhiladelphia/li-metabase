SELECT PermitNumber,
  PermitDescription As PermitType,
  apdttm As ApplicationDate,
  PermitIssueDate As IssueDate,
  FinalledDate,
  Status,
  SUM(PaidFees) PaidFees
FROM
  (SELECT p.PermitNumber,
    p.PermitDescription,
    p.apdttm,
    p.PermitIssueDate,
    p.FinalledDate,
    p.Status,
    fee1.amt AS PaidFees
  FROM imsv7.li_allpermits p,
    imsv7.apfee fee1
  WHERE p.apkey          = fee1.apkey (+)
  AND p.PermitIssueDate >= '01-JAN-16'
  AND fee1.paiddttm     IS NOT NULL
  )
GROUP BY PermitNumber,
  PermitDescription,
  Apdttm,
  PermitIssueDate,
  FinalledDate,
  Status
ORDER BY PermitIssueDate,
PermitDescription