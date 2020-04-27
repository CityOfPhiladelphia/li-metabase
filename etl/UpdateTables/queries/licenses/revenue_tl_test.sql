SELECT j.jobnumber,
       j.jobtype,
       fp.paymentreceiveddate paymentdate,
       fp.paymentamount amount,
       fp.feetype
FROM g_mvw_tl_jobs j,
     g_mvw_fee_payment_test fp
WHERE j.jobid = fp.referencedobjectid
      AND fp.paymentreceiveddate >= add_months (trunc (sysdate, 'MM'), - 25)
      AND j.jobtype IN (
    'Amendment',
    'Application',
    'Renewal'
)
    --  AND j.jobnumber = 'TR-2017-006573'