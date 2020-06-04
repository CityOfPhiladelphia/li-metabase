SELECT perm.permitnumber,
       perm.permittype,
       perm.createddate,
       perm.issuedate,
       perm.completeddate,
       perm.permitstatus,
       pay.paymentdistamount paidfees,
       pay.paymentreceiveddate paiddate
FROM (SELECT DISTINCT jobid,
                      permitnumber,
                      permitdescription permittype,
                      createddate,
                      issuedate,
                      completeddate,
                      permitstatus
      FROM g_mvw_permits
      WHERE issuedate >= '01-JAN-16'
            AND permittype <> 'Property Certificate'
     ) perm,
     g_mvw_fee fee,
     g_mvw_payment pay
WHERE perm.jobid = fee.referencedobjectid (+)
      AND fee.feeobjectid = pay.feeobjectid (+)
      AND pay.paymentreceiveddate IS NOT NULL