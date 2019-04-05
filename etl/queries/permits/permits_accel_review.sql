SELECT DISTINCT b.apno PermitNumber,
  b.APDTTM PermitApplicationDate,
  b.issdttm PermitIssueDate,
  defn.apdesc PermitDescription,
  (
  CASE
    WHEN b.worktype IS NOT NULL
    THEN b.worktype
    ELSE '(none)'
  END ) WorkType,
  fee.TotalAccelReviewFeesPaidAmount,
  fee.CountOfAccelReviewFeesPaid,
  act.SumReviewActualTime,
  act.SumReviewTimeDiff
FROM imsv7.apbldg b,
  imsv7.apdefn defn,
  (SELECT b.apkey,
    SUM(f.amt) TotalAccelReviewFeesPaidAmount,
    COUNT(f.apfeekey) CountOfAccelReviewFeesPaid
  FROM imsv7.apbldg b,
    imsv7.apfee f
  WHERE b.APDTTM >= '01-JAN-2018'
  AND b.APDTTM    < TO_DATE(TO_CHAR(SYSDATE,'MM/DD/YYYY'),'MM/DD/YYYY')
  AND b.apkey     = f.apkey
  AND f.stat      = 'P'
  AND (f.feedesc LIKE '%ACCELERATED%'
  OR f.FEEDESC LIKE '%ACCELARATED%')
  GROUP BY b.apkey
  ) fee,
  (SELECT b.apkey,
    SUM(a.actltm) SumReviewActualTime,
    SUM(a.compdttm - a.startdttm) SumReviewTimeDiff
  FROM imsv7.apbldg b,
    imsv7.apact a
  WHERE b.APDTTM >= '01-JAN-2018'
  AND b.APDTTM    < TO_DATE(TO_CHAR(SYSDATE,'MM/DD/YYYY'),'MM/DD/YYYY')
  AND b.apkey     = a.apkey
  AND a.comp      = 'Y'
  AND a.stat      = '1'
  GROUP BY b.apkey
  ) act
WHERE b.apdefnkey = defn.apdefnkey
AND b.apkey       = fee.apkey
AND b.apkey       = act.apkey (+)
AND b.APDTTM     >= '01-JAN-2018'
AND b.APDTTM      < TO_DATE(TO_CHAR(SYSDATE,'MM/DD/YYYY'),'MM/DD/YYYY')
AND b.issdttm    IS NOT NULL
ORDER BY permitnumber
