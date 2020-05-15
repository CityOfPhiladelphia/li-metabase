SELECT permitnumber,
       permittype,
       createddate,
       issuedate,
       completeddate,
       permitstatus,
       paidfees,
       systemofrecord
FROM (SELECT sub.permitnumber,
             sub.permittype,
             sub.createddate,
             sub.issuedate,
             sub.completeddate,
             sub.permitstatus,
             SUM (paidfees) OVER (
                 PARTITION BY permitnumber, trunc (issuedate)
             ) paidfees,
             sub.systemofrecord,
             ROW_NUMBER () OVER (
                 PARTITION BY permitnumber, trunc (issuedate)
                 ORDER BY systemofrecord ASC
             ) seq_no
      FROM (SELECT permitnumber,
                   permittype,
                   createddate,
                   issuedate,
                   completeddate,
                   permitstatus,
                   paidfees,
                   'ECLIPSE' systemofrecord
            FROM ecl_permits_fees
            UNION
            SELECT permitnumber,
                   permittype,
                   applicationdate createddate,
                   issuedate,
                   finalleddate completeddate,
                   status permitstatus,
                   paidfees,
                   'HANSEN' systemofrecord
            FROM permits_fees
      ) sub
     )
WHERE seq_no = 1