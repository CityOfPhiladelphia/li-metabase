SELECT 
  par.permitnumber,
  par.PermitApplicationDate,
  par.PermitIssueDate,
  par.PermitDescription,
  par.WorkType,
  par.TotalAccelReviewFeesPaidAmount,
  par.CountOfAccelReviewFeesPaid,
  par.SumReviewActualTime,
  par.SumReviewTimeDiff,
  bds1.BUSINESSDAYSSINCE BDSinceApplicationDate,
  bds2.BUSINESSDAYSSINCE BDSinceIssueDate,
  (
  CASE
    WHEN par.PermitIssueDate is not null
    THEN bds2.BUSINESSDAYSSINCE - bds1.BUSINESSDAYSSINCE
    ELSE bds1.BUSINESSDAYSSINCE
  END ) BDInReview,
  (
  CASE
    WHEN bds2.BUSINESSDAYSSINCE - bds1.BUSINESSDAYSSINCE <= 5
    THEN 'Within SLA'
    ELSE 'Outside SLA'
  END ) SLACompliance
FROM permits_accel_review par,
  BUSINESS_DAYS_SINCE_2017 bds1,
  BUSINESS_DAYS_SINCE_2017 bds2
WHERE TO_DATE(TO_CHAR(par.PermitApplicationDate, 'mm')
  || TO_CHAR(par.PermitApplicationDate, 'dd')
  || TO_CHAR(par.PermitApplicationDate, 'yyyy'), 'MMDDYYYY') = bds1.DATEOFYEAR (+)
AND TO_DATE(TO_CHAR(par.PermitIssueDate, 'mm')
  || TO_CHAR(par.PermitIssueDate, 'dd')
  || TO_CHAR(par.PermitIssueDate, 'yyyy'), 'MMDDYYYY') = bds2.DATEOFYEAR (+)