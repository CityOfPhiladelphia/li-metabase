SELECT p.permitnumber,
       p.permitdescription permittype,
       p.apdttm applicationdate,
       p.permitissuedate issuedate,
       p.finalleddate,
       p.status,
       fee1.amt AS paidfees,
       fee1.paiddttm paiddate,
       fee1.feedesc feedescription,
       p.bldgarea,
       p.declaredvalue
FROM imsv7.li_allpermits p,
     imsv7.apfee fee1
WHERE p.apkey = fee1.apkey (+)
      AND p.permitissuedate >= '01-JAN-16'
      AND fee1.paiddttm IS NOT NULL