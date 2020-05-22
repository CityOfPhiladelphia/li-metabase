SELECT DISTINCT j.jobnumber,
                j.jobtype,
                pay.paymentreceiveddate paymentdate,
                fee.feebaseamount amount,
                fee.feetype
FROM g_mvw_bl_jobs j,
     g_mvw_fee fee,
     g_mvw_payment pay
WHERE j.jobid = fee.referencedobjectid
      AND fee.feeobjectid = pay.feeobjectid
      AND pay.paymentreceiveddate >= add_months (trunc (sysdate, 'MM'), - 25)