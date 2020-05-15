SELECT p.permitnumber,
       p.permitdescription permittype,
       p.createddate,
       p.issuedate,
       p.completeddate,
       p.permitstatus,
       fp.paymentamount paidfees,
       fp.paymentreceiveddate paiddate
FROM g_mvw_permits p,
     g_mvw_fee_payment fp
WHERE p.jobid = fp.referencedobjectid (+)
      AND p.issuedate >= '01-JAN-16'
      AND fp.paymentreceiveddate IS NOT NULL
      AND p.permittype <> 'Property Certificate'