SELECT perm.permitnumber,
       perm.permitdescription permittype,
       perm.createddate,
       perm.issuedate,
       perm.completeddate,
       perm.permitstatus,
       pay.paymentdistamount paidfees,
       pay.paymentreceiveddate paiddate
FROM g_mvw_permits perm,
     g_mvw_fee fee,
     g_mvw_payment pay
WHERE perm.jobid = fee.referencedobjectid (+)
      AND fee.feeobjectid = pay.feeobjectid (+)
      AND perm.issuedate >= '01-JAN-16'
      AND pay.paymentreceiveddate IS NOT NULL
      AND perm.permittype <> 'Property Certificate'