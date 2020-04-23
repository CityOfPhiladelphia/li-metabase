SELECT j.jobnumber,
       j.jobtype,
       fp.paymentreceiveddate paymentdate,
       fp.paymentamount amount,
       fp.feetype
FROM g_mvw_tl_jobs j,
     g_mvw_fee_payment fp
WHERE j.jobid = fp.referencedobjectid
      --AND fp.receiveddate >= add_months (trunc (sysdate, 'MM'), - 25)
      AND fp.paymentreceiveddate >= '01-JAN-2017'
      AND j.jobtype IN (
    'Amendment',
    'Application',
    'Renewal'
)
    --  AND j.jobnumber = 'TR-2017-006573'