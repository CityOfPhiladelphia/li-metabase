SELECT permitnumber,
       upper (permittype) permittype,
       createddate,
       issuedate,
       completeddate,
       upper (permitstatus) permitstatus,
       paidfees,
       paiddate,
       'ECLIPSE' systemofrecord,
       feedescription
FROM ecl_permits_fees_dates
UNION ALL
SELECT permitnumber,
       permittype,
       applicationdate createddate,
       issuedate,
       finalleddate completeddate,
       status permitstatus,
       paidfees,
       paiddate,
       'HANSEN' systemofrecord,
       initcap(feedescription) feedescription
FROM permits_fees_dates