SELECT permitnumber,
       permitdescription permittype,
       createddate,  
       issuedate,  
       completeddate, 
       permitstatus,
       SUM (paymentamount) paidfees
FROM (SELECT p.permitnumber,
             p.permitdescription,
             p.createddate,
             p.issuedate,
             p.completeddate,
             p.permitstatus,
             fp.paymentamount
      FROM g_mvw_permits p,
           g_mvw_fee_payment fp
      WHERE p.jobid = fp.referencedobjectid (+)
            AND p.issuedate >= '01-JAN-16'
            AND fp.paymentreceiveddate IS NOT NULL
            AND p.permittype <> 'Property Certificate'
     )
GROUP BY permitnumber,
         permitdescription,
         createddate,
         issuedate,
         completeddate,
         permitstatus
ORDER BY issuedate,
         permitdescription